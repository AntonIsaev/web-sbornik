class InstitutionsController < ApplicationController
  add_bootstrap_breadcrumb I18n.t("breadcrumbs.root", :default => "Index"), "/"

  before_action :authenticate_user!, except: [:index, :show]

  def index
    @institutions = Institution.all.order('institutions.title')
    
    add_bootstrap_breadcrumb I18n.t("institutions.index.title", :default => "Index"), institutions_path
  end
  
  def show
    @institution = Institution.find(params[:id])
    
    add_bootstrap_breadcrumb I18n.t("institutions.index.title", :default => "Index"), institutions_path
    add_bootstrap_breadcrumb @institution.title, institution_path(@institution)
  end

  def new
    if not user_signed_in?
      redirect_to institutions_path, :flash => { :danger => t('helpers.flashes.no_create', :default => "You have no permissions to do such action") }
    else  
      @institution = Institution.new
    end  
    
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
      
      if params[:author_id] != nil
        @author = Author.find(params[:author_id])
        add_bootstrap_breadcrumb @author.name_full, author_path(@author, :journal_id => @journal.id, :publication_id => @publication.id, :article_id => @article.id)
        
        if params[:degree_id] != nil
          @degree = @author.degrees.find(params[:degree_id])  
          add_bootstrap_breadcrumb I18n.t("degrees.edit.title"), edit_author_degree_path(@author, @degree, :journal_id => @journal.id, :publication_id => @publication.id, :article_id => @article.id)
          add_bootstrap_breadcrumb I18n.t("institutions.new.title"), new_institution_path(:journal_id => @journal.id, :publication_id => @publication.id, :article_id => @article.id, :author_id => @author_id, :degree_id => @degree.id)
        else  
          add_bootstrap_breadcrumb I18n.t("degrees.new.title"), new_author_degree_path(@author, :journal_id => @journal.id, :publication_id => @publication.id, :article_id => @article.id)
          add_bootstrap_breadcrumb I18n.t("institutions.new.title"), new_institution_path(:journal_id => @journal.id, :publication_id => @publication.id, :article_id => @article.id, :author_id => @author_id)
        end  
      else
        add_bootstrap_breadcrumb I18n.t("degrees.new.title"), new_journal_publication_article_paternity_path(@journal, @publication, @article)
      end  
      
    else
      add_bootstrap_breadcrumb I18n.t("institutions.index.title", :default => "Index"), institutions_path
      add_bootstrap_breadcrumb I18n.t("institutions.new.title"), new_institution_path
    end  
  end
  
  def edit
    @institution = Institution.find (params[:id])
    
    if has_user_rights
      add_bootstrap_breadcrumb I18n.t("institutions.index.title", :default => "Index"), institutions_path
      add_bootstrap_breadcrumb @institution.title, institution_path(@institution)
      add_bootstrap_breadcrumb I18n.t("institutions.edit.title"), edit_institution_path(@institution)
    else
      redirect_to institution_path(@institution), :flash => { :danger => t('helpers.flashes.no_edit', :default => "You have no permissions to do such action") }
    end  

  end

  def create
    @institution = Institution.create(institution_params)
    @institution.user_id = current_user.id
 
    if @institution.save
      if params[:journal_id] != nil
        @journal = Journal.find(params[:journal_id])
        @publication = @journal.publications.find(params[:publication_id])
        @article = @publication.articles.find(params[:article_id]) 
        if params[:author_id] != nil
          @author = Author.find(params[:author_id])
          if params[:degree_id] != nil
            @degree = @author.degrees.find(params[:degree_id])  
            redirect_to edit_author_degree_path(@author, @degree, :journal_id => @journal.id, :publication_id => @publication.id, :article_id => @article.id, :institution_id => @institution.id)
          else
            redirect_to new_author_degree_path(@author, :journal_id => @journal.id, :publication_id => @publication.id, :article_id => @article.id, :institution_id => @institution.id)
          end
        else  
          redirect_to journal_publication_article_path(@journal, @publication, @article)
        end    
      else
        redirect_to institutions_path
      end
    else
      render 'new'
    end
  end
  
  def update
    @institution = Institution.find(params[:id])
 
    if @institution.update(institution_params)
      if params[:journal_id] != nil
        @journal = Journal.find(params[:journal_id])
        @publication = @journal.publications.find(params[:publication_id])
        @article = @publication.articles.find(params[:article_id]) 
        if params[:author_id] != nil
          @author = Author.find(params[:author_id])
          if params[:degree_id] != nil
            @degree = @author.degrees.find(params[:degree_id])  
            redirect_to edit_author_degree_path(@author, @degree, :journal_id => @journal.id, :publication_id => @publication.id, :article_id => @article.id, :institution_id => @institution.id)
          else
            redirect_to new_author_degree_path(@author, :journal_id => @journal.id, :publication_id => @publication.id, :article_id => @article.id, :institution_id => @institution.id)
          end
        else  
          redirect_to journal_publication_article_path(@journal, @publication, @article)
        end    
      else
        redirect_to institution_path(@institution)
      end
    else
      render 'edit'
    end
  end
  
  def destroy
    @institution = Institution.find(params[:id])
    if has_user_rights
      @institution.destroy
      redirect_to institutions_path
    else
      redirect_to institution_path(@institution), :flash => { :danger => t('helpers.flashes.no_delete', :default => "You have no permissions to do such action") }
    end  
  end
  
private  
  def institution_params
    params.require(:institution).permit(:title, :postaddress, :webaddress, :titleingenitive, :checkedbyadmin, :objectcreator)
  end  
  
  def has_user_rights
    user_signed_in? && (@institution.user_id == current_user.id || @current_user.admin?)
  end
end
