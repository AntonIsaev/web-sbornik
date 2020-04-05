# Degrees, регалии авторов
class DegreesController < ApplicationController
  add_bootstrap_breadcrumb I18n.t("breadcrumbs.root", :default => "Index"), "/"

  def index
    @author = Author.find(params[:author_id])
    redirect_to author_path(@author)
  end
  
  def show
    @author = Author.find(params[:author_id])
    redirect_to author_path(@author)
  end
  
  def new
    @author = Author.find(params[:author_id])
    
    if has_user_rights
      @degree = @author.degrees.new

      if params[:journal_id] != nil
        @journal = Journal.find(params[:journal_id])
        @publication = @journal.publications.find(params[:publication_id])
        @article = @publication.articles.find(params[:article_id]) 

        add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
        add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
        add_bootstrap_breadcrumb I18n.t("publications.index.title"), journal_publications_path(@journal)
        add_bootstrap_breadcrumb @publication.title, journal_publication_path(@journal, @publication)
        add_bootstrap_breadcrumb I18n.t("articles.index.title"), journal_publication_articles_path(@journal, @publication)
        add_bootstrap_breadcrumb @article.title, journal_publication_article_path(@journal, @publication, @article)
        add_bootstrap_breadcrumb I18n.t("paternities.show.title"), new_journal_publication_article_paternity_path(@journal, @publication, @article)
        add_bootstrap_breadcrumb @author.name_full, author_path(@author, :journal_id => @journal.id, :publication_id => @publication.id, :article_id => @article.id)
        add_bootstrap_breadcrumb I18n.t("degrees.new.title"), new_journal_publication_article_paternity_path(@journal, @publication, @article)
      else
        add_bootstrap_breadcrumb I18n.t("authors.index.title", :default => "Index"), journals_path
        add_bootstrap_breadcrumb @author.name_full, author_path(@author)
      end
    else  
      redirect_to author_path(@author), :flash => { :danger => t('helpers.flashes.no_create', :default => "You have no permissions to do such action") }
    end  
  end
  
  def edit
    @author = Author.find(params[:author_id])
    
    if has_user_rights
      @degree = @author.degrees.find(params[:id])

      if params[:journal_id] != nil
        @journal = Journal.find(params[:journal_id])
        @publication = @journal.publications.find(params[:publication_id])
        @article = @publication.articles.find(params[:article_id]) 

        add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
        add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
        add_bootstrap_breadcrumb I18n.t("publications.index.title"), journal_publications_path(@journal)
        add_bootstrap_breadcrumb @publication.title, journal_publication_path(@journal, @publication)
        add_bootstrap_breadcrumb I18n.t("articles.index.title"), journal_publication_articles_path(@journal, @publication)
        add_bootstrap_breadcrumb @article.title, journal_publication_article_path(@journal, @publication, @article)
        add_bootstrap_breadcrumb I18n.t("paternities.show.title"), new_journal_publication_article_paternity_path(@journal, @publication, @article)
        add_bootstrap_breadcrumb @author.name_full, author_path(@author, :journal_id => @journal.id, :publication_id => @publication.id, :article_id => @article.id)
        add_bootstrap_breadcrumb I18n.t("degrees.edit.title"), new_journal_publication_article_paternity_path(@journal, @publication, @article)
      else  
        add_bootstrap_breadcrumb I18n.t("authors.index.title", :default => "Index"), journals_path
        add_bootstrap_breadcrumb @author.name_full, author_path(@author)
      end
    else
      redirect_to author_path(@author), :flash => {:danger => t('helpers.flashes.no_edit', :default => "You have no permissions to do such action")}
    end  
  end

  def create
    @author = Author.find(params[:author_id])
    @degree = @author.degrees.create(degree_params)
 
    if @degree.save
      if params[:journal_id] != nil
        @journal = Journal.find(params[:journal_id])
        @publication = @journal.publications.find(params[:publication_id])
        @article = @publication.articles.find(params[:article_id]) 
        redirect_to author_path(@author, :journal_id => @journal.id, :publication_id => @publication.id, :article_id => @article.id)
      else
        redirect_to author_path(@author)
      end  
    else
      render 'new'
    end
  end
  
  def update
    @author = Author.find(params[:author_id])
    @degree = @author.degrees.find(params[:id])
 
    if @degree.update(degree_params)
      if params[:journal_id] != nil
        @journal = Journal.find(params[:journal_id])
        @publication = @journal.publications.find(params[:publication_id])
        @article = @publication.articles.find(params[:article_id]) 
        redirect_to author_path(@author, :journal_id => @journal.id, :publication_id => @publication.id, :article_id => @article.id)
      else
        redirect_to author_path(@author)
      end  
    else
      render 'edit'
    end
  end
  
  def destroy
    @author = Author.find(params[:author_id])
    
    if has_user_rights
      @degree = @author.degrees.find(params[:id])
      @degree.destroy
  
      if params[:journal_id] != nil
        @journal = Journal.find(params[:journal_id])
        @publication = @journal.publications.find(params[:publication_id])
        @article = @publication.articles.find(params[:article_id]) 
        redirect_to author_path(@author, :journal_id => @journal.id, :publication_id => @publication.id, :article_id => @article.id)
      else
        redirect_to author_path(@author)
      end  
    else
      redirect_to author_path(@author), :flash => { :danger => t('helpers.flashes.no_delete', :default => "You have no permissions to do such action") }
    end      
  end
  
  def sort
    @author = Author.find(params[:author_id])
    @degrees = @author.degrees.order('degrees.position ASC')
    
    @degrees.each do |d|
      d.position = params[:degree].index(d.position.to_s)+1
      d.save
    end
    
    render :nothing => true    
  end
  
private  
  def degree_params
    params.require(:degree).permit(:info, :institution_id)
  end  
  
  def has_user_rights
    user_signed_in? && (@author.user_id == current_user.id || current_user.author_id == @author.id || @current_user.admin?)
  end
end