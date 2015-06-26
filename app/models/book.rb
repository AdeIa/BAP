require 'kaminari'
require 'marc'
require "uri"
require 'net/https'
require 'open-uri'

class Book < ActiveRecord::Base
  self.primary_key = 'czu_number'
  has_many :loans
  has_many :reservations


  #return title of book
  def self.get_name(czu_number)
    find_by(czu_number: czu_number).name
  end

  #return author of book
  def self.get_author(czu_number)
    find_by(czu_number: czu_number).author_name
  end
  
  #paginate catalog books
	def self.paginate_data(data, page, count_of_items)
   # records_count = Setting.get_books_per_page
		Kaminari.paginate_array(data).page(page).per(count_of_items)
	end

  #retrieves data from the text database fond.xml
	def self.get_books_data(records)
		reader = Book.read_data('./data/fond.xml')
		for record in reader
  			records <<  record
  	end
	end 	

  #update attribute kii_number 
  def self.write_data(number,book_id)
    book = Book.search_by_czu_number(book_id)
    book.update_attribute :kii_number, number
    return true
  end

   #update attribute kii_number 
  def self.write_multiple_data(edit_records)
    edit_records.each do |edit_record|
      book = Book.search_by_czu_number(edit_record[0])
      book.update_attribute :kii_number, edit_record[1]
    end

    return true
  end

  # find books by title
	def self.search_by_title(query)
     query = query.delete(' ').delete(']').delete('[').gsub /\t/, ''
     return Book.all.select{|b| 
        if !b.name.nil?
          I18n.transliterate(b.name).delete(' ').delete(']').delete('[') =~ /#{query}/i
        end
      }
  end

  # find books by author
  def self.search_by_author(similary_records, query)
    query = query.gsub(/,/,"").gsub( /\t/, '')
    words = query.split(" ")
    query = query.delete(' ')
    temp = Array.new
    books = Book.all
    books.each do |b| 
      if !b.author_name.nil?
        author = I18n.transliterate(b.author_name).gsub(/,/,"").gsub( /\t/, '').delete(' ')
        if author =~ /#{query}/i
          temp << b
        else
          words.each do |word|
            if author =~ /#{word}/i
              similary_records << b
              break
            end
          end
        end
      end
    end
    return temp

  end

  # find books by isbn
  def self.search_by_ISBN(query)
    query = query.gsub(/-/,"")
     return Book.all.select{|b| 
        if !b.isbn.nil?
          I18n.transliterate(b.isbn).gsub(/-/,"") =~ /#{query}/i
        end
      }
  end

  # returns a book with the corresponding czu_number
  def self.search_by_czu_number(id)
    find_by(czu_number: id)
  end

  # downloads the library catalog from Aleph
  def self.download_data   
    uri = URI('url_odstraneno')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    store = OpenSSL::X509::Store.new
    store.set_default_paths
    store.add_cert(OpenSSL::X509::Certificate.new(File.read("./lib/rapid.crt"))) 
    http.cert_store = store

    response = http.request(Net::HTTP::Get.new("/X?op=find&code=wsl&request=51&base=czu01&user_name=odstraneno&user_password=odstraneno"))
    doc = Nokogiri::XML(response.body.force_encoding('UTF-8'))
    
    no_records = 0 
    set_number = 0

    doc.search('//no_records').each do |node|
      no_records = node.content.to_i
    end

    doc.search('//set_number').each do |node|
      set_number = node.content
    end
    count = (no_records/100.0).ceil #count of files for data

    for i in 1..count
      file = File.open("./data/fond#{i}.xml","w")
       response = http.request(Net::HTTP::Get.new("odstraneno_z_du"))
       File.open(file.path,'w') do |f|
         f.write response.body.force_encoding('UTF-8')
       end
    end
    
    if merge_data(count,http)
      return  true
    end

    return false

  end   

  # text database conversion to relational database
  def self.save_into_database(path) 
    reader = Book.read_data(path)
    for record in reader
      if Book.exists?(:czu_number => record.try(:[], '001').value)
        book = Book.search_by_czu_number(record.try(:[], '001').value)
        book.update_attribute :quantity , record.try(:[], '090').try(:[], 'b')
        book.update_attribute :name , record.try(:[], '245').try(:[], 'a').to_s + record.try(:[], '245').try(:[], 'b').to_s + record.try(:[], '245').try(:[], 'c').to_s
        book.update_attribute :author_name , record.try(:[], '100').try(:[], 'a')
        book.update_attribute :isbn , record.try(:[], '020').try(:[], 'a')
        book.update_attribute :edition , record.try(:[], '250').try(:[], 'a')
        book.update_attribute :publishing , record.try(:[], '260').try(:[], 'a').to_s + record.try(:[], '260').try(:[], 'b').to_s + record.try(:[], '260').try(:[], 'c').to_s
        book.update_attribute :form , record.try(:[], '655').try(:[], 'a')
        book.update_attribute :description , record.try(:[], '300').try(:[], 'a').to_s + record.try(:[], '300').try(:[], 'b').to_s + record.try(:[], '300').try(:[], 'c').to_s
        book.update_attribute :language , record.try(:[], '041').try(:[], 'a')
      else
        Book.create(
        :czu_number => record.try(:[], '001').value, 
       :quantity => record.try(:[], '090').try(:[], 'b'),
       :name => record.try(:[], '245').try(:[], 'a').to_s + record.try(:[], '245').try(:[], 'b').to_s + record.try(:[], '245').try(:[], 'c').to_s,
       :author_name => record.try(:[], '100').try(:[], 'a'),
       :isbn => record.try(:[], '020').try(:[], 'a'),
       :edition => record.try(:[], '250').try(:[], 'a'),
       :publishing => record.try(:[], '260').try(:[], 'a').to_s + record.try(:[], '260').try(:[], 'b').to_s + record.try(:[], '260').try(:[], 'c').to_s,
       :form => record.try(:[], '655').try(:[], 'a'),
       :description => record.try(:[], '300').try(:[], 'a').to_s + record.try(:[], '300').try(:[], 'b').to_s + record.try(:[], '300').try(:[], 'c').to_s,
       :language => record.try(:[], '041').try(:[], 'a'))
      end
    end
    return true
  end

  private
    
    # allow read data from text database
    def self.read_data(path)
      MARC::XMLReader.new(path, :parser=>'libxml', :external_encoding => "UTF-8")
    end

    # allow write data into text database
    def self.write(path)
      MARC::XMLWriter.new(path)
    end

    # return array of records from ruby-marc reader
    def self.get_records_in_reader(path)
      reader = Book.read_data(path)
      records=Array.new
      for record in reader
            records <<  record
      end
      return records
    end
    
    # merge files into one and perform OAI conversion to MARC XML 
    def self.merge_data(count,http)
      if count > 1
        %x[./script/first_merge.sh]
        for i in 3..count
          j = i+1
          %x[./script/merge.sh #{i} #{j}]
        end
        doc = Nokogiri::XML(File.read("./data/result#{count+1}.xml"))
      else
        doc = Nokogiri::XML(File.read("./data/fond1.xml"))
      end

      #set new root collection
      collection = Nokogiri::XML::Node.new "collection", doc
      collection.set_attribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance")
      collection.set_attribute("xsi:schemaLocation", "http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd")
      collection.set_attribute("xmlns", "http://www.loc.gov/MARC21/slim")
      collection.children = doc.root
      doc.root = collection


      overwrite_fixfield(doc)
      overwrite_varfield(doc)
      overwrite_subfield(doc)

      File.open('./data/result.xml','w') {|f| f.write doc.to_xml}
      
      if count > 1
        %x[./script/rm_file.sh result#{count+1}]
      else
        %x[./script/rm_file.sh fond1]        
      end

      if !update_fond(http)
        return false
      end

      return true 
    end

    # update text database 
    def self.update_fond(http)
      actual_fond_reader = Book.read_data('./data/result.xml')
      writer = Book.write('./data/fond.xml')
      for record in actual_fond_reader
        quantity = get_records_quantity(http, record['001'].value.delete('^0-9') )
        record.append(MARC::DataField.new('090', '0',  ' ', ['b', quantity.to_s]))
        writer.write(record)          
      end

      writer.close()

      return true
    end

    # download information about quantity of record
    def self.get_records_quantity(http, par_doc_number)
      response = http.request(Net::HTTP::Get.new("/X?op=item-data&doc_number=#{par_doc_number}&base=czu01&user_name=odstraneno&user_password=odstraneno"))
      doc = Nokogiri::XML(response.body.force_encoding('UTF-8'))
      counter = 0
      doc.search('//collection').each do |node|
        if node.content == "51"
          counter +=1
        end
      end
      return counter
    end

    # overwrite all fixfiled element by MARC XML format
    def self.overwrite_fixfield(doc)
       doc.search('//fixfield').each do |node|
        if node.attribute("id").value == "LDR"
          node.name = 'leader'
          node.remove_attribute("id")
          node.content = node.content.gsub(/\s+/, " ").strip
        elsif node.attribute("id").value == "FMT"
          node.remove
        else
          if node.attribute("id").value.to_i < 10
            node.name = 'controlfield'
          else
             node.name = 'datafield'
          end
          node.set_attribute("tag", node.attribute("id").value)
          node.remove_attribute("id")
          node.content = node.content.gsub(/\s+/, " ").strip
        end        
      end

    end

    # overwrite all varfield element by MARC XML format
    def self.overwrite_varfield(doc)
       doc.search('//varfield').each do |node|
        if node.attribute("id").value == "STA"
          node.remove
        end
        node.name = 'datafield'
        node.set_attribute("tag", node.attribute("id").value)
        node.set_attribute("ind1", node.attribute("i1").value)
        node.set_attribute("ind2", node.attribute("i2").value)
        node.remove_attribute("id")
        node.remove_attribute("i1")
        node.remove_attribute("i2")
      end
    end

    # overwrite all subfield element by MARC XML format
    def self.overwrite_subfield(doc)
      doc.search('//subfield').each do |node|
        node.set_attribute("code", node.attribute("label").value)
        node.remove_attribute("label")
        node.content = node.content.gsub(/\s+/, " ").strip
      end   
    end

end
