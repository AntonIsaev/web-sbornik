# Comments, дополнительные файлы-приложения к статье: экспертиза, чеки об оплате и т.д.
class CommentsController < ApplicationController
  add_bootstrap_breadcrumb I18n.t("breadcrumbs.root", :default => "Index"), "/"
  
  def index
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:article_id])
    
    # списка вложений отдельным окном нет и не будет, потому просто выбрасываю назад в статью, если случайно открылась эта ссылка
    redirect_to journal_publication_article_path(@journal, @publication, @article)
  end

  def show
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:article_id])

    # показ вложения отдельным окном нет и не будет, потому просто выбрасываю назад в статью, если случайно открылась эта ссылка
    redirect_to journal_publication_article_path(@journal, @publication, @article)
  end

  def new
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:article_id])
    
    if has_user_rights
      @comment = @article.comments.new

      add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
      add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
      add_bootstrap_breadcrumb I18n.t("publications.index.title"), journal_publications_path(@journal)
      add_bootstrap_breadcrumb @publication.title, journal_publication_path(@journal, @publication)
      add_bootstrap_breadcrumb I18n.t("articles.index.title"), journal_publication_articles_path(@journal, @publication)
      add_bootstrap_breadcrumb @article.title, journal_publication_article_path(@journal, @publication, @article)
      add_bootstrap_breadcrumb I18n.t("comments.new.title"), new_journal_publication_article_comment_path(@journal, @publication, @article)
    else
      redirect_to journal_publication_article_path(@journal, @publication, @article), :flash => { :danger => t('helpers.flashes.no_create', :default => "You have no permissions to do such action") }
    end  
  end
  
  def edit
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:article_id])
    

    if has_user_rights
      @comment = @article.comments.find(params[:id])

      add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
      add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
      add_bootstrap_breadcrumb I18n.t("publications.index.title"), journal_publications_path(@journal)
      add_bootstrap_breadcrumb @publication.title, journal_publication_path(@journal, @publication)
      add_bootstrap_breadcrumb I18n.t("articles.index.title"), journal_publication_articles_path(@journal, @publication)
      add_bootstrap_breadcrumb @article.title, journal_publication_article_path(@journal, @publication, @article)
      add_bootstrap_breadcrumb I18n.t("comments.edit.title"), edit_journal_publication_article_comment_path(@journal, @publication, @article, @comment)
    else
      redirect_to journal_publication_article_path(@journal, @publication, @article), :flash => { :danger => t('helpers.flashes.no_edit', :default => "You have no permissions to do such action") }
    end  
  end
 
  def create
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    
    if @comment.save
      @comment.user_id = current_user.id
      @comment.save
      redirect_to journal_publication_article_path(@journal, @publication, @article)
    else
      render 'new'
    end  
  end
  
  def update
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
 
    if @comment.update(comment_params)
       redirect_to journal_publication_article_path(@journal, @publication, @article)
    else
      render 'edit'
    end
  end   

  def destroy
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:article_id])
    if has_user_rights
      @comment = @article.comments.find(params[:id])
      @comment.file = nil
      @comment.destroy
      redirect_to journal_publication_article_path(@journal, @publication, @article)
    else
      redirect_to journal_publication_article_path(@journal, @publication, @article), :flash => { :danger => t('helpers.flashes.no_delete', :default => "You have no permissions to do such action") }
    end  
  end

  private
    def comment_params
      params.require(:comment).permit(:commenter, :body, :file, :file_attachment_type, :comment_type_id)
    end
    
    def has_user_rights
      user_signed_in? && (@article.user_id == current_user.id || @article.proofreader_id == current_user.id || @journal.user_id == current_user.id || @publication.uroles.where('user_id = '+current_user.id.to_s+' AND role_id = 0').count != 0)
    end

end