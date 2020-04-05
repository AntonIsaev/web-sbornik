# Articles, статьи как объекты системы
class ArticlesController < ApplicationController
  add_bootstrap_breadcrumb I18n.t("breadcrumbs.root", :default => "Index"), "/"

  before_action :authenticate_user!, except: [:index, :show]

  def index
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    
    if @publication.publication_status_id == 1 || @publication.publication_status_id == 2 || (user_signed_in? && (current_user.admin? || current_user.id == @journal.user_id))
      @articles = @publication.articles.order('articles.title')
    
      add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
      add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
      add_bootstrap_breadcrumb I18n.t("publications.index.title"), journal_publications_path(@journal)
      add_bootstrap_breadcrumb @publication.title, journal_publication_path(@journal, @publication)
      add_bootstrap_breadcrumb I18n.t("articles.index.title"), journal_publication_articles_path(@journal, @publication)
    else  
      redirect_to journal_publication_path(@journal, @publication), :flash => { :danger => t('helpers.flashes.no_index', :default => "You have no permissions to do such action") }
    end      
  end

  def show 
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:id])
    
    # разбил на 3 куска, чтобы уменьшить число запросов к БД
    can_show_article = @publication.publication_status_id == 2 && @article.materials.count != 0
    
    if not can_show_article
      can_show_article = has_user_rights
      if not can_show_article 
        if user_signed_in? && current_user.author_id != nil
        # статья доступна на просмотр автору, если он в числе соавторов статьи
          can_show_article = @article.paternities.where('author_id = '+current_user.author_id.to_s).count != 0
        end  
      end  
    end  
   
    if can_show_article
      add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
      add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
      add_bootstrap_breadcrumb I18n.t("publications.index.title"), journal_publications_path(@journal)
      add_bootstrap_breadcrumb @publication.title, journal_publication_path(@journal, @publication)
      add_bootstrap_breadcrumb I18n.t("articles.index.title"), journal_publication_articles_path(@journal, @publication)
      add_bootstrap_breadcrumb @article.title, journal_publication_article_path(@journal, @publication, @article)
    else
      redirect_to journal_publication_articles_path(@journal, @publication), :flash => { :danger => t('helpers.flashes.no_show', :default => "You have no permissions to do such action") }
    end  
  end

  def new
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])

    if @publication.publication_status_id == 1 && user_signed_in? || (user_signed_in? && current_user.admin?)
      @article = @publication.articles.new
      
      add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
      add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
      add_bootstrap_breadcrumb I18n.t("publications.index.title"), journal_publications_path(@journal)
      add_bootstrap_breadcrumb @publication.title, journal_publication_path(@journal, @publication)
      add_bootstrap_breadcrumb I18n.t("articles.index.title"), journal_publication_articles_path(@journal, @publication)
      add_bootstrap_breadcrumb I18n.t("articles.new.title"), new_journal_publication_article_path(@journal, @publication)
    else  
      redirect_to journal_publication_articles_path(@journal, @publication), :flash => { :danger => t('helpers.flashes.no_create', :default => "You have no permissions to do such action") }
    end  
  end

  def edit
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:id])

    if has_user_rights
      add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
      add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
      add_bootstrap_breadcrumb I18n.t("publications.index.title"), journal_publications_path(@journal)
      add_bootstrap_breadcrumb @publication.title, journal_publication_path(@journal, @publication)
      add_bootstrap_breadcrumb I18n.t("articles.index.title"), journal_publication_articles_path(@journal, @publication)
      add_bootstrap_breadcrumb @article.title, journal_publication_article_path(@journal, @publication, @article)
      add_bootstrap_breadcrumb I18n.t("articles.edit.title"), edit_journal_publication_article_path(@journal, @publication, @article)
    else
      redirect_to journal_publication_article_path(@journal, @publication, @article), :flash => { :danger => t('helpers.flashes.no_edit', :default => "You have no permissions to do such action") }
    end  
  end

  def create
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.create(article_params)
    @article.user_id = current_user.id
    
    if @article.save
      if current_user.author_id != nil && current_user.author_id > 0
        @paternity = Paternity.new
        @paternity.article_id = @article.id
        @paternity.author_id = current_user.author_id
        @paternity.position = 1
        @paternity.save
      end  
      
      # drop pages count to 0 for portion.ftype=6 - need to recalculate pages count for this block
      @portions = @publication.portions.where('portions.ftype = 6')
      @portions.each do |p|
        p.pages_count = 0
        p.save
      end  
      
      # send message to author about success with adding new article
      @system_user = User.find(0)
      
      @subject = I18n.t('notify_messages.new_article_added.title.author', article: @article.title)
      
      @s_journal = view_context.link_to(@journal.title, journal_path(@journal)).html_safe
      @s_publication = view_context.link_to(@publication.title, journal_publication_path(@journal, @publication)).html_safe
      @s_article = view_context.link_to(@article.title, root_url.chop+journal_publication_article_path(@journal, @publication, @article)).html_safe
      @s_journal_rules = view_context.link_to(I18n.t('helpers.links.open'), root_url.chop+@journal.arules.url).html_safe
      @s_author = current_user.username
      
      @body = I18n.t('notify_messages.new_article_added.body.author', 
        journal: @s_journal, 
        publication: @s_publication,
        article: @s_article,
        journal_rules: @s_journal_rules)
      
      @system_user.send_message(current_user, @body, @subject, false)
      
      # send message to chief editor about new article to view
      @subject = I18n.t('notify_messages.new_article_added.title.chief_editor', article: @article.title)
      @body = I18n.t('notify_messages.new_article_added.body.chief_editor',
        journal: @s_journal, 
        publication: @s_publication,
        article: @s_article,
        author: @s_author)
      
      @system_user.send_message(User.find(@journal.user_id), @body, @subject, false)
          
      # send message to all chief assistants about new article to view
      @subject = I18n.t('notify_messages.new_article_added.title.chief_assistant', article: @article.title)
      @body = I18n.t('notify_messages.new_article_added.body.chief_assistant',
        journal: @s_journal, 
        publication: @s_publication,
        article: @s_article,
        author: @s_author)
      
      @publication.uroles.where('role_id = 0').each do |urole|
        @system_user.send_message(User.find(urole.user_id), @body, @subject, false)
      end  

      redirect_to journal_publication_article_path(@journal, @publication, @article)
    else
      render 'new'
    end
  end
 
  def update
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:id])
 
    if @article.update(article_params)
       redirect_to journal_publication_article_path(@journal, @publication, @article)
    else
      render 'edit'
    end
  end

  def destroy
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:id])
    
    if has_user_rights_strong
      @article.destroy
      redirect_to journal_publication_articles_path(@journal, @publication)
    else  
      redirect_to journal_publication_article_path(@journal, @publication, @article), :flash => { :danger => t('helpers.flashes.no_delete', :default => "You have no permissions to do such action") }
    end  
  end
 
private
  def article_params
    params.require(:article).permit(:title, :title_en, :udk, :annotation, :annotation_en, :keywords, :keywords_en)
  end
    
  def has_user_rights_strong
    # автор статьи
    # главный редактор
    # помощник главного редактора
    # администратор системы
    user_signed_in? && (@article.user_id == current_user.id || current_user.id == @journal.user_id || @publication.uroles.where('user_id = '+current_user.id.to_s+' AND role_id = 0').count != 0 || current_user.admin?)
  end

  def has_user_rights
    # автор статьи
    # главный редактор
    # помощник главного редактора
    # технический корректор статьи
    # администратор системы
    has_user_rights_strong || (user_signed_in? && @current_user.id == @article.proofreader_id)
  end
  
end
