# Paternities, список авторов статьи
class PaternitiesController < ApplicationController
  add_bootstrap_breadcrumb I18n.t("breadcrumbs.root", :default => "Index"), "/"

  def index
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:article_id])
    
    # списка нет
    redirect_to journal_publication_article_path(@journal, @publication, @article)
  end

  def show
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:article_id])
    
    # формы показа нет
    redirect_to journal_publication_article_path(@journal, @publication, @article)
  end

  def new
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:article_id])
    
    if has_user_rights
      @paternity = @article.paternities.new

      add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
      add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
      add_bootstrap_breadcrumb I18n.t("publications.index.title"), journal_publications_path(@journal)
      add_bootstrap_breadcrumb @publication.title, journal_publication_path(@journal, @publication)
      add_bootstrap_breadcrumb I18n.t("articles.index.title"), journal_publication_articles_path(@journal, @publication)
      add_bootstrap_breadcrumb @article.title, journal_publication_article_path(@journal, @publication, @article)
      add_bootstrap_breadcrumb I18n.t("paternities.new.title"), new_journal_publication_article_paternity_path(@journal, @publication, @article)
    else
      redirect_to journal_publication_article_path(@journal, @publication, @article), :flash => { :danger => t('helpers.flashes.no_create', :default => "You have no permissions to do such action") }
    end  
  end
  
  def edit
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:article_id])
    
    # только создание или удаление авторства, редактировать тут нечего
    redirect_to journal_publication_article_path(@journal, @publication, @article)
  end
  
  def create
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:article_id])
    @paternity = @article.paternities.create(paternity_params)
    @paternity.user_id = current_user.id
    
    if @paternity.save
      redirect_to journal_publication_article_path(@journal, @publication, @article)
    else
      render 'new'
    end  
  end
  
  def destroy
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:article_id])
    if has_user_rights
      @paternity = @article.paternities.find(params[:id])
      @paternity.destroy
      redirect_to journal_publication_article_path(@journal, @publication, @article)
    else
      redirect_to journal_publication_article_path(@journal, @publication, @article), :flash => { :danger => t('helpers.flashes.no_delete', :default => "You have no permissions to do such action") }
    end  

  end

  def sort
    if user_signed_in?
      @journal = Journal.find(params[:journal_id])
      @publication = @journal.publications.find(params[:publication_id])
      @article = @publication.articles.find(params[:article_id])
      @paternities = @article.paternities.order('position')
     
      @paternities.each do |p|
        p.position = params[:paternity].index(p.position.to_s)+1
        p.save
      end
    end  
    
    render :nothing => true    
  end

private
  def paternity_params
    params.require(:paternity).permit(:position, :author_id)
  end
  
  def has_user_rights
    user_signed_in? && ((@journal.user_id == current_user.id) || (@publication.uroles.where('user_id = '+current_user.id.to_s+' AND role_id = 0').count != 0) || (@article.user_id == current_user.id) || current_user.admin?)
  end
  
 end