class BooksController < ApplicationController
  helper_method :sort_column, :sort_direction
  
  def download
    authenticate_admin!
    if Book.download_data()
      redirect_to settings_path, notice: 'Data úspěšně připravena.'
    else
      redirect_to settings_path, :flash => { :error => "Příprava dat se nezdařila." }
    end
  end

  def save_into_database
    authenticate_admin!
    if Book.save_into_database('./data/fond.xml')
       redirect_to settings_path, notice: 'Uložení do databáze proběhlo úspěšně.'
    else
      redirect_to settings_path,  :flash => { :error => 'Uložení do databáze se nezdařilo.'}
    end
  end

  def index
    @records = Book.all.order(sort_column + " " + sort_direction)
    @count_of_items = params[:page_value]
    @records = Book.paginate_data(@records, params[:page], @count_of_items)
  end

  def search
    @category = params[:category]
    @query = I18n.transliterate(params[:search])
    @records = Array.new
    @similary_records = Array.new
    if @query.empty?
      @records = nil
      return
    else
      if @category == "Titul"
        @records = Book.search_by_title(@query)
      elsif @category == "Autor"
        @records = Book.search_by_author(@similary_records, @query)
      else
        @records = Book.search_by_ISBN(@query)
      end
    end

  end

  def detail
    @loan_length = Setting.get_loan_time
    book_id = params[:id]
    @record = Book.search_by_czu_number(book_id)
    @user_id = nil
    @count_of_loans = Loan.check_loan(@record.czu_number)
    @user_ids = Loan.get_user_id(@record.czu_number)
    user_id = current_user.try(:id)
    @book_is_reserved_by_current_user = Reservation.check_user_reservation(@record.czu_number,user_id)
    @book_is_reserved = Reservation.check_book_reservation(@record.czu_number)
    @reservation_user_ids = Reservation.get_user_id(@record.czu_number)
  end

  def add_registration_number
    authenticate_admin!
    if Book.write_data(params[:number], params[:id])
      redirect_to books_detail_path(:id => params[:id]), notice: 'Evidenční číslo bylo úspěšně přidáno.'
    else
      redirect_to books_detail_path(:id => params[:id]), :flash => { :error => "Evidenční číslo se nepodařilo úspěšně zapsat." }
    end
  end

  def edit_multiple
    authenticate_admin!
    if !params[:book_ids].present?
      redirect_to books_path, :flash => { :error => "Nebyla vybrána žádná kniha pro editaci." }
      return
    end

    @records = Book.where(czu_number: params[:book_ids])
  end

  def update_multiple
    authenticate_admin!
    edit_records = params[:books]
    if Book.write_multiple_data(edit_records)
      redirect_to books_path, notice: 'Editace proběhla úspěšně.'
    else
      redirect_to books_path,  :flash => { :error => 'Editace se nezdařila.'}
    end
  end

   def destroy
    authenticate_admin!
    @book = Book.search_by_czu_number(params[:id])
    @book.destroy
    redirect_to books_path, :flash => { :notice => "Kniha byla úspěšně smazána." }    
  end

  private
    def sort_column
      Book.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
