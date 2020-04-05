# Uroles, роли при работе с журналом. Роли распределяет глав.редактор. Типы ролей:
# role_id = 0 - chief assistant
# role_id = 1 - proofreader
class UrolesController < ApplicationController

  def index
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    redirect_to journal_publication_path(@journal, @publication)
  end

  def new
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    
    if has_user_rights
      @urole = @publication.uroles.new
      add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
      add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
      add_bootstrap_breadcrumb I18n.t("publications.index.title"), journal_publications_path(@journal)
      add_bootstrap_breadcrumb @publication.title, journal_publication_path(@journal, @publication)
      add_bootstrap_breadcrumb I18n.t("uroles.index.title"), journal_publication_path(@journal, @publication)
      add_bootstrap_breadcrumb I18n.t("uroles.new.title"), new_journal_publication_urole_path(@journal, @publication)
    else  
      redirect_to journal_publication_path(@journal, @publication), :flash => { :danger => t('helpers.flashes.no_create', :default => "You have no permissions to do such action") }
    end  
  end
  
  def create
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @urole = @publication.uroles.create(urole_params)
 
    if @urole.save
      # ID главного редактора
      @urole.chief_id = @journal.user_id
      
      # ID непосредственного пользователя, заполняется если есть такой e-mail в базе
      @user = User.where('email = "'+@urole.email+'"').first
      if @user != nil
        @urole.user_id = @user.id
      else   
        @urole.user_id = 0
      end
      @urole.save
      
		  redirect_to journal_publication_path(@journal, @publication)
	  else
		  render 'new'
	  end
  end  
  
  def show
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    
    if has_user_rights
      @urole = @publication.uroles.find(params[:id])
        
      add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
      add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
      add_bootstrap_breadcrumb I18n.t("publications.index.title"), journal_publications_path(@journal)
      add_bootstrap_breadcrumb @publication.title, journal_publication_path(@journal, @publication)
      add_bootstrap_breadcrumb I18n.t("uroles.index.title"), journal_publication_path(@journal, @publication)
      add_bootstrap_breadcrumb @urole.email, journal_publication_urole_path(@journal, @publication, @urole)
    else
      redirect_to journal_publication_path(@journal, @publication), :flash => { :danger => t('helpers.flashes.no_show', :default => "You have no permissions to do such action") }
    end    
  end

  def edit
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    
    if has_user_rights
      @urole = @publication.uroles.find(params[:id])
      add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
      add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
      add_bootstrap_breadcrumb I18n.t("publications.index.title"), journal_publications_path(@journal)
      add_bootstrap_breadcrumb @publication.title, journal_publication_path(@journal, @publication)
      add_bootstrap_breadcrumb I18n.t("uroles.index.title"), journal_publication_path(@journal, @publication)
      add_bootstrap_breadcrumb @urole.email, journal_publication_urole_path(@journal, @publication, @urole)
      add_bootstrap_breadcrumb I18n.t("uroles.edit.title"), edit_journal_publication_urole_path(@journal, @publication, @urole)
    else  
      redirect_to journal_publication_path(@journal, @publication), :flash => { :danger => t('helpers.flashes.no_edit', :default => "You have no permissions to do such action") }
    end  
  end
  
  def update
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @urole = @publication.uroles.find(params[:id])
 
    if @urole.update(urole_params)
      # updating ID of chief editor
      @urole.chief_id = @journal.user_id
      
      # ID of user by itself, if this user exists in database (this e-mail exists in "users" table)
      @user = User.where('email = "'+@urole.email+'"').first
      
      if @user
        @urole.user_id = @user.id
        
        # send notification message + e-mail
        @s_journal = view_context.link_to(@journal.title, journal_path(@journal)).html_safe
        @s_publication = view_context.link_to(@publication.title, journal_publication_path(@journal, @publication)).html_safe
        @s_journal_rules = view_context.link_to(I18n.t('helpers.links.open'), root_url.chop+@journal.arules.url).html_safe
        @s_chief = User.find(@user.id).username
          
        if @urole.role_id == 0 # chief assistant
          @subject = I18n.t('notify_messages.role_is_appointed.subject.chief_assistant')
          
          @s_articles_list = view_context.link_to(I18n.t('helpers.links.open'), root_url.chop+journal_publication_articles_path(@journal, @publication)).html_safe
          @s_publication_pdf = view_context.link_to(I18n.t('materials.edit.pdf_create'), root_url.chop+journal_publication_pdf_path(@journal, @publication)).html_safe
          
          @body = I18n.t('notify_messages.role_is_appointed.body.chief_assistant',
            journal: @s_journal, 
            publication: @s_publication,
            journal_rules: @s_journal_rules,
            chief: @s_chief,
            articles_list: @s_articles_list,
            publication_pdf: @s_publication_pdf)
        elsif @urole.role_id == 1 # proofreader
          @subject = t('notify_messages.role_is_appointed.subject.proofreader')

          @s_article = view_context.link_to(@article.title, root_url.chop+journal_publication_article_path(@journal, @publication, @article)).html_safe
          @s_chief_role = t('uroles.new.role'+@urole.role_id.to_s)
          
          @body = I18n.t('notify_messages.role_is_appointed.body.proofreader',
            journal: @s_journal, 
            publication: @s_publication,
            article: @s_article,
            journal_rules: @s_journal_rules,
            chief: @s_chief,
            chief_role: @s_chief_role)
        end
        
        @system_user = User.where('id = 0').first
        @system_user.send_message(@user, @body, @subject, false)
        
      else   
        @urole.user_id = 0  # it means that user with such e-mail is absent in database

        # TODO: отправка на e-mail, пользователь не зарегистрирован
#        @system_user.send_message(@user, "You have the role now", "You have the role now! You are invited to the "+@publication.title+" publication of "+@journal.title+" journal as a "+t('uroles.new.role'+@urole.role_id.to_s)+"!")
      end
      
      @urole.save

      redirect_to journal_publication_path(@journal, @publication)
    else
      render 'edit'
    end
  end
  
  def destroy
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @urole = @publication.uroles.find(params[:id])
    
    if has_user_rights
      @urole.destroy
      redirect_to journal_publication_path(@journal, @publication)
    else  
      redirect_to journal_publication_path(@journal, @publication), :flash => { :danger => t('helpers.flashes.no_delete', :default => "You have no permissions to do such action") } 
    end  
  end
  
private  
  def urole_params
    params.require(:urole).permit(:chief_id, :email, :user_id, :publication_id, :role_id)
  end
  
  def has_user_rights
    user_signed_in? && (@journal.user_id == current_user.id || current_user.admin?)
  end

end
