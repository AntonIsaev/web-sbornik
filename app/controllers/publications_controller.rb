# Publications, выпуски сборника
class PublicationsController < ApplicationController
  require_relative 'declare_portion_types_constants'

  add_bootstrap_breadcrumb I18n.t("breadcrumbs.root", :default => "Index"), "/"

  before_action :authenticate_user!, except: [:index, :show]

  def index
    @journal = Journal.find(params[:journal_id])
    redirect_to journal_path(@journal)
  end
  
  def show
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:id])
    
    if @publication.publication_status_id == 1 || @publication.publication_status_id == 2 || has_user_rights_strong
      add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
      add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
      add_bootstrap_breadcrumb @publication.title, journal_publication_path(@journal, @publication)
    else
      redirect_to journal_publications_path(@journal), :flash => { :danger => t('helpers.flashes.no_show', :default => "You have no permissions to do such action") }
    end  
  end
  
  def new
    @journal = Journal.find(params[:journal_id])

    if has_user_rights_strong
      @publication = @journal.publications.new
      add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
      add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
      add_bootstrap_breadcrumb I18n.t("publications.new.title"), new_journal_publication_path(@journal)
    else  
      redirect_to journal_publications_path(@journal), :flash => { :danger => t('helpers.flashes.no_create', :default => "You have no permissions to do such action") }
    end  
  end
  
  def edit
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:id])
    
    if has_user_rights_strong
      add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
      add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
      add_bootstrap_breadcrumb @publication.title, journal_publication_path(@journal, @publication)
      add_bootstrap_breadcrumb I18n.t("publications.edit.title"), edit_journal_publication_path(@journal, @publication)
    else  
      redirect_to journal_publication_path(@journal, @publication), :flash => { :danger => t('helpers.flashes.no_edit', :default => "You have no permissions to do such action") }
    end  
  end

  def create
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.create(publication_params)
 
    if @publication.save
      # create default portions
      $i = 1
      $num = 13
      while $i <= $num  do
        @portion = @publication.portions.new
        @portion.ftype = $i
        @portion.add_to_contents = PortionType.find($i).add_to_contents
        @portion.is_numbering = PortionType.find($i).is_numbering
        @portion.save
        $i +=1
      end      
      
      @publication.save
      
		  redirect_to journal_publication_path(@journal, @publication)
	  else
		  render 'new'
	  end
  end
  
  def update
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:id])
 
    if @publication.update(publication_params)
      redirect_to journal_publication_path(@journal, @publication)
    else
      render 'edit'
    end
  end
  
  def destroy
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:id])
    
    if has_user_rights_strong
      @publication.destroy
      redirect_to journal_publications_path(@journal)
    else  
      redirect_to journal_publication_path(@journal, @publication), :flash => { :danger => t('helpers.flashes.no_delete', :default => "You have no permissions to do such action") } 
    end  
  end
  
  def pdf
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    if not user_signed_in? 
      redirect_to journal_publication_path(@journal, @publication), :flash => { :danger => t('helpers.flashes.no_create', :default => "You have no permissions to do such action") }
    elsif has_user_rights
      add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
      add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
      add_bootstrap_breadcrumb @publication.title, journal_publication_path(@journal, @publication)
      add_bootstrap_breadcrumb I18n.t("publications.pdf.title"), journal_publication_pdf_path(@journal, @publication)
    else  
      redirect_to journal_publication_path(@journal, @publication), :flash => { :danger => t('helpers.flashes.no_create', :default => "You have no permissions to do such action") }
    end
  end

private  
  def publication_params
    params.require(:publication).permit(:pubno, :pubtxt, :publication_status_id, :publication_cover, :publish_plan, :introduction, :pages_multiplicity, :publication_first_page, :publication_second_page, :publication_editorial_team, :publication_introduction, :publication_thanks, :publication_last_page, :publication_cover_end, :publication_blank, :website_cover, :ISBN, :file)
  end  
  
  def has_user_rights
    user_signed_in? && (current_user.admin? || (@journal.user_id == current_user.id) || (@publication.uroles.where('user_id = '+current_user.id.to_s+' AND role_id = 0').count != 0))
  end
  
  def has_user_rights_strong
    user_signed_in? && (current_user.admin? || @journal.user_id == current_user.id)
  end
end
