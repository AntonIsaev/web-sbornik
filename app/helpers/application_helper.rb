module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = I18n::t('appname')
    if page_title.empty?
      base_title
    else
      addon = ''
      "#{page_title} | #{base_title} #{addon}"
    end
  end 
  
  # check if item has help 
  def has_help(id)
    item = HelpTopic.where(:for_item => id).first
    if item != nil
      return item.id
    else
      return -1
    end
  end

  # check if user is super admin
  def is_user_super_admin
    return user_signed_in? && current_user.id == 0
  end 

  # begin of help button for item in application
  def hb(item_id_to_help)
    render 'layouts/print_help_section_begin', :locals => {:help_item_id => item_id_to_help}
  end

  # end of help button for item in application
  def he(item_id_to_help)
    render 'layouts/print_help_section_end', :locals => {:help_item_id => item_id_to_help}
  end   
  
  def global_param(param)
    b = GlobalParam.where(:param_name => param).first
	if b != nil
      return b.val
	else
	  return 'NaN (' + param + ')'
    end	
  end
end
