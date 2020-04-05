class JournalsController < ApplicationController
  add_bootstrap_breadcrumb I18n.t("breadcrumbs.root", :default => "Index"), "/"
  
  before_action :authenticate_user!, except: [:index, :show]

  def index
    # фильтрация показа журналов происходит на уровне view, т.к. здесь сложная фильтрация и нужно анализировать каждый журнал на возможность его показа в общем списке
    journals_tmp = Journal.order('updated_at DESC')
	@journals = []
	
	journals_tmp.each do |journal|
	
		# anonymous user role  
		if not user_signed_in? 
		  can_show_this_journal = journal.publications.where('publication_status_id = 1').count != 0 

		  if can_show_this_journal == false
			can_show_this_journal = journal.publications.where('publication_status_id = 2').count != 0 
		  end  
		else 
		  
		  # admin role
		  if current_user.admin?
			can_show_this_journal = true
		  end  
			
		  # anonymous role repeated
		  if can_show_this_journal == false
			can_show_this_journal = journal.publications.where('publication_status_id = 1').count != 0 
		  end  
		  
		  if can_show_this_journal == false
			can_show_this_journal = journal.publications.where('publication_status_id = 2').count != 0 
		  end  
		  
		  # proofreader role
		  if can_show_this_journal == false
			can_show_this_journal = journal.articles.where('articles.proofreader_id = "'+current_user.id.to_s+'"').count != 0
		  end

		  # chief_assistant role
		  if can_show_this_journal == false
			can_show_this_journal = can_show_this_journal || journal.uroles.where('user_id = '+current_user.id.to_s+' AND chief_id = '+journal.user_id.to_s+' AND role_id = 0').count != 0
		  end  

		  # chief role 
		  can_show_this_journal = can_show_this_journal || journal.user_id == current_user.id
		  
		end
		
		if can_show_this_journal 
		  @journals << journal
		end
	  
	end
	
    add_bootstrap_breadcrumb I18n.t("journals.index.title"), journals_path
  end
  
  def show
    @journal = Journal.find(params[:id])
    
    if has_user_rights 
      request = ''
    else
      request = 'publication_status_id = 1 OR publication_status_id = 2'
    end    
    
    if request != '' && @journal.publications.where(request).count == 0
      redirect_to journals_path, :flash => { :danger => t('helpers.flashes.no_show', :default => "You have no permissions to do such action") }
    else  
      add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
      add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
    end  
  end
  
  def new
    # TODO: проверка на наличие оплаченной подписки
    if user_signed_in?
      @journal = Journal.new
      add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
      add_bootstrap_breadcrumb I18n.t("journals.new.title"), new_journal_path
    else
      redirect_to journals_path, :flash => { :danger => t('helpers.flashes.no_create', :default => "You have no permissions to do such action") }
    end  
  end
  
  def edit
    @journal = Journal.find (params[:id])
    if has_user_rights_strong
      add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
      add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
      add_bootstrap_breadcrumb I18n.t("journals.edit.title"), edit_journal_path(@journal)
    else  
      redirect_to journal_path(@journal), :flash => { :danger => t('helpers.flashes.no_edit', :default => "You have no permissions to do such action") }
    end  
  end

  def create
    @journal = Journal.create(journal_params)
    if @journal.save
      @journal.user_id = current_user.id
      @journal.save

      redirect_to @journal
    else
      render 'new'
    end
  end
  
  def update
    @journal = Journal.find(params[:id])

    if @journal.update(journal_params)
      redirect_to @journal
    else
      render 'edit'
    end
  end
  
  def destroy
    @journal = Journal.find(params[:id])
    
    if has_user_rights_strong
      @journal.destroy
      redirect_to journals_path
    else
      redirect_to journal_path(@journal), :flash => { :danger => t('helpers.flashes.no_delete', :default => "You have no permissions to do such action") }
    end      
  end
  
private  
  def journal_params
    params.require(:journal).permit(:title, :descr, :user_id, :udk, :website, :editorial_board, :arules, :logo, :ISSN)
  end  
  
  def set_journal
    @journal = Journal.find params[:id]
    for_ownership_check(@journal)
  end
  
  def has_user_rights
    user_signed_in? && (current_user.admin? || @journal.user_id == current_user.id || Urole.where('user_id = '+current_user.id.to_s+' AND chief_id = '+@journal.user_id.to_s+' AND role_id = 0').count != 0)
  end
  
  def has_user_rights_strong
    user_signed_in? && (current_user.admin? || @journal.user_id == current_user.id)
  end
  
end
