class HelpTopicsController < ApplicationController
  def index
    @help_topics = HelpTopic.where(:parent_id => 0)
  end

  def new
    if user_signed_in? && current_user.id == 0
      @help_topic = HelpTopic.new
	  @help_topics = HelpTopic.all
      i = 0
      if !params[:help_item_id].blank?
        if HelpTopic.where(:for_item => params[:help_item_id]).count > 0
          while HelpTopic.where(:for_item => params[:help_item_id]+'_'+i.to_s).count > 0
            i += 1
          end
          @help_topic.for_item = params[:help_item_id]+'_'+i.to_s
        else
          @help_topic.for_item = params[:help_item_id]
        end
		neighbour = HelpTopic.where('parent_id = '+@help_topic.parent_id.to_s).order(:neighbour_id).last
		if neighbour != nil
		  @help_topic.neighbour_id = neighbour.neighbour_id + 1
		end	
      end
    else
      redirect_to help_topics_path, :flash => { :danger => t('helpers.flashes.no_create') }
    end
  end

  def edit
    if user_signed_in? && current_user.id == 0
      @help_topic = HelpTopic.find(params[:id])
	  @help_topics = HelpTopic.where('id <> '+params[:id])
    else
      redirect_to help_topics_path, :flash => { :danger => t('helpers.flashes.no_edit') }
    end
  end

  def show
    @help_topic = HelpTopic.find(params[:id])
    @help_topics = HelpTopic.where(:parent_id => 0)
  end

  def create
    if user_signed_in? && current_user.id == 0
      @help_topic = HelpTopic.create(help_topic_params)
      if @help_topic.save
		@help_topic.parent_id = params[:help_topic_parent][:id]
		@help_topic.parent_id = 0 if @help_topic.parent_id == nil
		@help_topic.neighbour_id = params[:help_topic_neighbour][:id]
		@help_topic.neighbour_id = 0 if @help_topic.neighbour_id == nil
		@help_topic.save
        redirect_to help_topics_path
      else
        render 'new'
      end
    else
      redirect_to help_topics_path, :flash => { :danger => t('helpers.flashes.no_create') }
    end
  end

  def update
    if user_signed_in? && current_user.id == 0
      @help_topic = HelpTopic.find(params[:id])
      if @help_topic.update(help_topic_params)
		@help_topic.parent_id = params[:help_topic_parent][:id]
		@help_topic.parent_id = 0 if @help_topic.parent_id == nil
		@help_topic.neighbour_id = params[:help_topic_neighbour][:id]
		@help_topic.neighbour_id = 0 if @help_topic.neighbour_id == nil
		@help_topic.save
        redirect_to help_topics_path
      else
        render 'edit'
      end
    else
      redirect_to help_topics_path, :flash => { :danger => t('helpers.flashes.no_edit') }
    end
  end

  def destroy
    if user_signed_in? && current_user.id == 0
      @help_topic = HelpTopic.find(params[:id])
      @help_topic.destroy
      redirect_to help_topics_path
    else
      redirect_to help_topics_path, :flash => { :danger => t('helpers.flashes.no_destroy') }
    end
  end
  
  def update_neighbours
	if params[:help_topic_id].blank? 
	  @curr_help_topic = nil
      @help_topics = HelpTopic.where('parent_id = ' + params[:help_t_id].to_s).order(:neighbour_id)
	else 
	  @curr_help_topic = HelpTopic.find(params[:help_topic_id]) 
      @help_topics = HelpTopic.where('parent_id = ' + params[:help_t_id].to_s + ' AND id <> ' + params[:help_topic_id]).order(:neighbour_id)
	end
  end

private

  def help_topic_params
    params.require(:help_topic).permit(:for_item, :title, :short_text, :long_text, :parent_id, :neighbour_id, :shows_count, :shows_count_mini, :help_t_id, :help_topic_parent => {}, :help_topic_neighbour => {})
  end 
end
