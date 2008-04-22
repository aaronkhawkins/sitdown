# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def display_standard_flashes(message = 'There were some problems with your submission:')
      if flash[:notice]
        flash_to_display, level = flash[:notice], 'notice'
      elsif flash[:warning]
        flash_to_display, level = flash[:warning], 'warning'
      elsif flash[:error]
        level = 'error'
        if flash[:error].instance_of? ActiveRecord::Errors
          flash_to_display = message
          flash_to_display << activerecord_error_list(flash[:error])
        else
          flash_to_display = flash[:error]
        end
      else
        return
      end
      content_tag 'div', flash_to_display, :class => "flash #{level}"
    end
end
