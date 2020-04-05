# Authors, авторы статей
class AuthorsController < ApplicationController
  add_bootstrap_breadcrumb I18n.t("breadcrumbs.root", :default => "Index"), "/"

  before_action :authenticate_user!, except: [:index, :show]

  def index
    @authors = Author.all
    
    add_bootstrap_breadcrumb I18n.t("authors.index.title", :default => "List of authors"), authors_path
  end
  
  def show
    @author = Author.find(params[:id])

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
      add_bootstrap_breadcrumb I18n.t("paternities.show.title"), journal_publication_article_path(@journal, @publication, @article)
      add_bootstrap_breadcrumb @author.name_full, author_path(@author, :journal_id => @journal.id, :publication_id => @publication.id, :article_id => @article.id)
    else
      add_bootstrap_breadcrumb I18n.t("authors.index.title", :default => "Index"), authors_path
      add_bootstrap_breadcrumb @author.name_full, author_path(@author)
    end
  end
  
  def new
    if has_user_rights
      @author = Author.new
      
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
        add_bootstrap_breadcrumb I18n.t("paternities.new.title"), new_journal_publication_article_paternity_path(@journal, @publication, @article)
        add_bootstrap_breadcrumb I18n.t("authors.new.title"), new_author_path(:journal_id => @journal.id, :publication_id => @publication.id, :article_id => @article.id)
      else
        add_bootstrap_breadcrumb I18n.t("authors.index.title", :default => "Index"), authors_path
        add_bootstrap_breadcrumb I18n.t("authors.new.title"), new_author_path
      end
    else  
      redirect_to authors_path, :flash => { :danger => t('helpers.flashes.no_create', :default => "You have no permissions to do such action") }
    end  
  end
  
  def edit
    @author = Author.find(params[:id])

    if has_user_rights && params[:user_set_author]
      current_user.author_id = @author.id
      current_user.save
      redirect_to persons_profile_path
    elsif has_user_rights_strong 
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
        add_bootstrap_breadcrumb I18n.t("paternities.show.title"), journal_publication_article_path(@journal, @publication, @article)
        add_bootstrap_breadcrumb @author.name_full, author_path(@author, :journal_id => @journal.id, :publication_id => @publication.id, :article_id => @article.id)
        add_bootstrap_breadcrumb I18n.t("authors.edit.title"), edit_author_path(:journal_id => @journal.id, :publication_id => @publication.id, :article_id => @article.id)
      else
        add_bootstrap_breadcrumb I18n.t("authors.index.title", :default => "Index"), authors_path
        add_bootstrap_breadcrumb @author.name_full, author_path(@author)
        add_bootstrap_breadcrumb I18n.t("authors.edit.title"), new_author_path
      end
    else
      redirect_to author_path(@author), :flash => {:danger => t('helpers.flashes.no_edit', :default => "You have no permissions to do such action")}
    end
  end

  def create
    @author = Author.create(author_params)
    @author.user_id = current_user.id
    
    if current_user.author_id == 0 || params[:user_set_author]
      current_user.author_id = @author.id
      current_user.save
    end  
 
    if @author.save
      if params[:journal_id] != nil
        @journal = Journal.find(params[:journal_id])
        @publication = @journal.publications.find(params[:publication_id])
        @article = @publication.articles.find(params[:article_id]) 
        redirect_to new_journal_publication_article_paternity_path(@journal, @publication, @article, :author_id => @author.id)
      else 
        if params[:user_set_author]
          redirect_to persons_profile_path
        else
          redirect_to author_path(@author)
        end
      end  
    else
      render 'new'
    end
  end
  
  def update
    @author = Author.find(params[:id])
 
    if @author.update(author_params)
      if params[:journal_id] != nil
        @journal = Journal.find(params[:journal_id])
        @publication = @journal.publications.find(params[:publication_id])
        @article = @publication.articles.find(params[:article_id]) 

        redirect_to journal_publication_article_path(@journal, @publication, @article)
      else  
        redirect_to @author
      end  
    else
      render 'new'
    end

  end
  
  def destroy
    @author = Author.find(params[:id])
    
    if has_user_rights_strong
      User.where('author_id = '+@author.id.to_s).each do |user|
        user.author_id = 0
        user.save
      end  
      
      # TODO: удаление / передача статей, созданных журналов, авторов и заведений

      @author.destroy
	
      if params[:journal_id] != nil
        @journal = Journal.find(params[:journal_id])
        @publication = @journal.publications.find(params[:publication_id])
        @article = @publication.articles.find(params[:article_id]) 
        redirect_to journal_publication_article_path(@journal, @publication, @article)
      else
        redirect_to authors_path
      end  
    else
      redirect_to author_path(@author), :flash => { :danger => t('helpers.flashes.no_delete', :default => "You have no permissions to do such action") }
    end  
  end
  
private  
  def author_params
    params.require(:author).permit(:surname, :mainname, :middlename, :email, :moretext)
  end   
  
  def has_user_rights
    user_signed_in?
  end

  def has_user_rights_strong
    user_signed_in? && (@author.user_id == current_user.id)
  end
 
end
