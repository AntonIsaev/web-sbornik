# Materials, собственно материал статьи + история его изменений
class MaterialsController < ApplicationController
  add_bootstrap_breadcrumb I18n.t("breadcrumbs.root", :default => "Index"), "/"
  
  require 'doc2pdfclient'
  
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
    @material = @article.materials.find(params[:id])
    
    base_breadcrumbs
    add_bootstrap_breadcrumb I18n.t("materials.show.title"), journal_publication_article_material_path(@journal, @publication, @article, @material)
  end

  def new
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:article_id])
    
    if has_user_rights
      @material = @article.materials.new
    else
      redirect_to journal_publication_article_path(@journal, @publication, @article), :flash => { :danger => t('helpers.flashes.no_create', :default => "You have no permissions to do such action") }
    end  

    base_breadcrumbs
    if @article.materials.count == 0
      add_bootstrap_breadcrumb I18n.t("materials.new.material"), new_journal_publication_article_comment_path(@journal, @publication, @article)
    else  
      add_bootstrap_breadcrumb I18n.t("materials.new.version"), new_journal_publication_article_comment_path(@journal, @publication, @article)
    end  
  end
  
  def edit
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:article_id])
    
    # TODO: редактировать можно только последний материал в списке материалов к данной статье. 
    # Пока что остался хак - можно набрать путь с /edit в адресной строке. Только нужно знать номер материала
    if has_user_rights
      @material = @article.materials.find(params[:id])
    else
      redirect_to journal_publication_article_path(@journal, @publication, @article), :flash => { :danger => t('helpers.flashes.no_edit', :default => "You have no permissions to do such action") }
    end  

    base_breadcrumbs
    add_bootstrap_breadcrumb I18n.t("materials.show.title"), edit_journal_publication_article_material_path(@journal, @publication, @article, @material)
  end
 
  def create
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:article_id])
    @material = @article.materials.create(material_params)
    
    @material.checked_by_author_id = 0
    @material.checked_by_proofreader_id = 0
    @material.checked_by_chief_assistant_id = 0
    @material.checked_by_chief_id = 0
    
    if @material.save
      s = File.extname(@material.file.path).downcase
      if (s == '.doc') || (s == '.docx') || (s == '.rtf')
      
        Dir.mktmpdir() do |dir|
          pdf_filename = '/'+File.basename(@material.file.path, s)+'.pdf'
          client = Doc2PDFClient.new('192.168.1.80', '55000')
          client.convert(@material.file.path, dir+pdf_filename)
          File.open(dir + pdf_filename) do |f|
            @material.file_pdf = nil
            @material.file_pdf = f
          end  
        end  
        
        reader = PDF::Reader.new(@material.file_pdf.path)
        @material.pages_count = reader.page_count
        @material.save
      end  
      
      redirect_to journal_publication_article_path(@journal, @publication, @article)
    else
      render 'new'
    end  
  end
  
  def update
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:article_id])
    @material = @article.materials.find(params[:id])
    
    if @material.update(material_params)
      if current_user.id == @article.user_id && @material.checked_by_author_id == 1
        @material.checked_by_author_id = current_user.id
      end        
      if current_user.id == @article.proofreader_id && @material.checked_by_proofreader_id == 1
        @material.checked_by_proofreader_id = current_user.id
      end        
      if Urole.where('user_id = '+current_user.id.to_s+' AND chief_id = '+@journal.user_id.to_s+' AND role_id = 0 AND publication_id = '+@publication.id.to_s).count != 0 && @material.checked_by_chief_assistant_id == 1
        @material.checked_by_chief_assistant_id = current_user.id
      end        
      if current_user.id == @journal.user_id && @material.checked_by_chief_id == 1
        @material.checked_by_chief_id = current_user.id
      end        
      @material.save
    
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
      @material = @article.materials.find(params[:id])
      @material.file = nil
      @material.destroy
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
      @materials = @article.materials.order('position')
     
      @materials.each do |m|
        m.position = params[:material].index(m.position.to_s)+1
        m.save
      end
    end  
    
    render :nothing => true    
  end 
  
  def pdf
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @article = @publication.articles.find(params[:article_id])
    @material = @article.materials.find(params[:material_id])

    if user_signed_in? && (@article.user_id == current_user.id || @article.proofreader_id == current_user.id || @journal.user_id == current_user.id || current_user.admin? || false)
      s = File.extname(@material.file.path).downcase
      if (s == '.doc') || (s == '.docx') || (s == '.rtf')
        Dir.mktmpdir() do |dir|
          pdf_filename = '/'+File.basename(@material.file.path, File.extname(@material.file.path))+'.pdf'
          client = Doc2PDFClient.new('192.168.1.80', '8080')
          client.convert(@material.file.path, dir+pdf_filename)
          File.open(dir + pdf_filename) do |f|
            @material.file_pdf = nil
            @material.file_pdf = f
          end  
          
          reader = PDF::Reader.new(@material.file_pdf.path)
          @material.pages_count = reader.page_count
        end  
        
        @material.save
      end  
    end  
      
    redirect_to edit_journal_publication_article_material_path(@journal, @publication, @article, @material)
  end

private
  def material_params
    params.require(:material).permit(:file, :checked_by_author_id, :checked_by_author, :checked_by_proofreader_id, :checked_by_proofreader, :checked_by_chief_assistant_id, :checked_by_chief_assistant, :checked_by_chief_id, :checked_by_chief, :position, :file_pdf, :comment, :is_bibliography_ready, :is_images_ready, :is_formulas_ready)
  end

  def has_user_rights
    user_signed_in? && ((@journal.user_id == current_user.id) || (@publication.uroles.where('user_id = '+current_user.id.to_s+' AND role_id = 0').count != 0) || (@article.user_id == current_user.id) || current_user.admin?)
  end
  
  def base_breadcrumbs
    add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
    add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
    add_bootstrap_breadcrumb I18n.t("publications.index.title"), journal_publications_path(@journal)
    add_bootstrap_breadcrumb @publication.title, journal_publication_path(@journal, @publication)
    add_bootstrap_breadcrumb I18n.t("articles.index.title"), journal_publication_articles_path(@journal, @publication)
    add_bootstrap_breadcrumb @article.title, journal_publication_article_path(@journal, @publication, @article)
  end
  
end
