# Appointments, техкорректоры статей + история изменений
class AppointmentsController < ApplicationController
  add_bootstrap_breadcrumb I18n.t("breadcrumbs.root", :default => "Index"), "/"
  before_action :get_journal_publication_article
  
  def index
    # списка отдельным окном нет и не будет, потому просто выбрасываю назад в статью, если случайно открылась эта ссылка
    redirect_to journal_publication_article_path(@journal, @publication, @article)
  end

  def show
    # показ отдельным окном нет и не будет, потому просто выбрасываю назад в статью, если случайно открылась эта ссылка
    redirect_to journal_publication_article_path(@journal, @publication, @article)
  end

  def new
    if has_user_rights
      @appointment = @article.appointments.new

      add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
      add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
      add_bootstrap_breadcrumb I18n.t("publications.index.title"), journal_publications_path(@journal)
      add_bootstrap_breadcrumb @publication.title, journal_publication_path(@journal, @publication)
      add_bootstrap_breadcrumb I18n.t("articles.index.title"), journal_publication_articles_path(@journal, @publication)
      add_bootstrap_breadcrumb @article.title, journal_publication_article_path(@journal, @publication, @article)
      add_bootstrap_breadcrumb I18n.t("appointments.new.title"), new_journal_publication_article_appointment_path(@journal, @publication, @article)
    else
      redirect_to journal_publication_article_path(@journal, @publication, @article), :flash => { :danger => t('helpers.flashes.no_create', :default => "You have no permissions to do such action") }
    end  
  end
  
  def edit
    # there is no editing appointments, only adding, so it will be able to see history. But it's possible to delete appointment
    if has_user_rights
      redirect_to new_journal_publication_article_appointment_path(@journal, @publication, @article)
    else
      redirect_to journal_publication_article_path(@journal, @publication, @article), :flash => { :danger => t('helpers.flashes.no_edit', :default => "You have no permissions to do such action") }
    end  
  end
 
  def create
    @appointment = @article.appointments.create(appointment_params)
    
    if @appointment.save
      @appointment.chief_id = @journal.user_id
      @appointment.user_id_set = current_user.id
      @appointment.save
      
      @article.proofreader_id = @appointment.user_id
      @article.save
      
      redirect_to journal_publication_article_path(@journal, @publication, @article)
    else
      render 'new'
    end  
  end
  
  def update
    # no update and edit! Create and delete only
    redirect_to journal_publication_article_path(@journal, @publication, @article)
  end   

  def destroy
    if has_user_rights
      @appointment = @article.appointments.find(params[:id])
      @appointment.destroy
      redirect_to journal_publication_article_path(@journal, @publication, @article)
    else
      redirect_to journal_publication_article_path(@journal, @publication, @article), :flash => { :danger => t('helpers.flashes.no_delete', :default => "You have no permissions to do such action") }
    end  
  end

private
  def get_journal_publication_article
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:article_id])
  end

  def appointment_params
    params.require(:appointment).permit(:chief_id, :user_id_set, :user_id, :article_id, :date_plan, :date_fact, :comment, :score)
  end

  def has_user_rights
    # автор статьи
    # главный редактор
    # помощник главного редактора
    # технический корректор статьи
    # администратор системы
    user_signed_in? && (@article.user_id == current_user.id || @article.proofreader_id == current_user.id || @journal.user_id == current_user.id || @publication.uroles.where('user_id = '+current_user.id.to_s+' AND role_id = 0').count != 0)
  end

end