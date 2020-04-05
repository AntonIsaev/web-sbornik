module HelpTopicsHelper
  
  def contain_active_item(menu_item, active_item)
    b = false
    if active_item != nil
	  k = HelpTopic.where('parent_id = ' + menu_item.id.to_s + ' and id = ' + active_item.id.to_s)
      b = HelpTopic.where('parent_id = ' + menu_item.id.to_s + ' and id = ' + active_item.id.to_s).count > 0
	  if !b
	    k.each do |child|
		  b = b or contain_active_item(child, active_item)
		end
      end
	else   
	  b = false
	end  
	return b
  end
  
  def draw_help_menu(root_help_topics, active_item = nil, draw_button_menu = false)
    s = ''

    if draw_button_menu
	  s = s + '<nav class="navbar navbar-default"><div class="container-fluid"> <div class="navbar-header"> <a class="navbar-brand" href="'+help_topics_path+'">'+t('help_topics.index.menu_title')+'</a> <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-menubuilder-help"><span class="sr-only">' + t('menu.show_hide') + '</span><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span> </button> </div><div class="clearfix"></div>';
	end
	
	s = s + '<div class="collapse navbar-collapse navbar-menubuilder-help"> <ul class="nav navmenu-nav">'
	  
    root_help_topics.order(:neighbour_id).each do |help_topic|
	  s = s + draw_help_item(help_topic, active_item)
	end
    s = s + '</ul></div>'
	
	if draw_button_menu
	  s = s + '</div></nav>'
	end
	return s.html_safe
  end
  
  def draw_help_item(help_topic, active_item = nil)
    s = ''
	childs = HelpTopic.where(:parent_id => help_topic.id)
	if childs.count > 0
	  s = s + '<li class="dropdown'+help_topic.id.to_s
	  if contain_active_item(help_topic, active_item)
	    s = s + ' open'
	  end
	  s = s + '"><a href="'+help_topic_path(help_topic)+'" class="dropdown-toggle" data-toggle="dropdown">'+help_topic.title+'<b class="caret"></b></a><ul class="dropdown-menu navmenu-nav" role="menu">'
	  childs.each do |child|
	    s = s + draw_help_item(child, active_item)
	  end
	  s = s + '</ul></li>'
	else
      s = s + '<li'
	  if active_item != nil && active_item.id == help_topic.id
	    s = s + ' class="active"'
	  end
	  s = s + '><a href="'+help_topic_path(help_topic)+'">'+help_topic.title+'</a></li>'
	end
	
	return s
  end
end
