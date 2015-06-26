module ApplicationHelper
	# method sortable: http://railscasts.com/episodes/228-sortable-table-columns
	def sortable(column, title = nil, page_value = nil)
	  title ||= column.titleize
	   css_class = (column == sort_column) ? "current #{sort_direction}" : nil
	  direction =  sort_direction == "asc" ? "desc" : "asc"
	   link_to title, {:sort => column, :direction => direction, :page_value => page_value}, {:class => css_class}
	end

	def flash_class(level)
	    case level
	        when "notice" then 
	         "alert alert-success alert-dismissible"
	        when "success" then 
	         "alert alert-success alert-dismissible"
	        when "error" then  
	        "alert alert-danger alert-dismissible"
	        when "alert" then  
	        "alert alert-danger alert-dismissible"
	    end
	end

	def is_active?(link_path)
	  current_page?(link_path) ? "active" : ""
	end
end
