# Portions, составные части выпуска сборника
class PortionsController < ApplicationController
  def index
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    
    redirect_to journal_publication_path(@journal, @publication)
  end

  def new
    @journal = Journal.find(params[:journal_id])
	@publication = @journal.publications.find(params[:publication_id])
	if PortionType.count == 0
	  redirect_to journal_publication_path(@journal, @publication), :flash => { :danger => t('helpers.flashes.no_exist', :default => "You have no permissions to do such action") + " (SQL_NO_PORTION_TYPES_IN_DB)" }
	else

	  if has_user_rights
		@portion = @publication.portions.new
		
		# set position param: new item adds as the last item
		if @publication.portions.count > 0
		  @portion.position = @publication.portions.order('position DESC').first.position + 1
		  @portion.save
		end  
		
		add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
		add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
		add_bootstrap_breadcrumb I18n.t("publications.index.title"), journal_publications_path(@journal)
		add_bootstrap_breadcrumb @publication.title, journal_publication_path(@journal, @publication)
		add_bootstrap_breadcrumb I18n.t("portions.new.title"), new_journal_publication_portion_path(@journal, @publication)
	  else  
		redirect_to journal_publication_path(@journal, @publication), :flash => { :danger => t('helpers.flashes.no_create', :default => "You have no permissions to do such action") }
	  end  
	end
  end
  
  def edit
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    
    if not has_user_rights
      redirect_to journal_publication_path(@journal, @publication), :flash => { :danger => t('helpers.flashes.no_edit', :default => "You have no permissions to do such action") }
    else  
      @portion = @publication.portions.find(params[:id])
      
      add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
      add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
      add_bootstrap_breadcrumb I18n.t("publications.index.title"), journal_publications_path(@journal)
      add_bootstrap_breadcrumb @publication.title, journal_publication_path(@journal, @publication)
      add_bootstrap_breadcrumb I18n.t("portions.edit.title"), edit_journal_publication_portion_path(@journal, @publication, @portion)
    end  

  end
  
  def show
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @portion = @publication.portions.find(params[:id])

    redirect_to edit_journal_publication_portion_path(@journal, @publication, @portion)
  end
  
  def create
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @portion = @publication.portions.create(portion_params)
    
    if @portion.save
       # set position param: new item adds as the last item
	   if @publication.portions.count > 0
		  @portion.position = @publication.portions.order('position DESC').first.position + 1
		  @portion.save
	   end  
      redirect_to journal_publication_path(@journal, @publication)
    else
      render 'new'
    end
  end

  def update
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    @portion = @publication.portions.find(params[:id])
 
    if @portion.update(portion_params)
      redirect_to journal_publication_path(@journal, @publication)
    else
      render 'edit'
    end
  end

  def destroy
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    if has_user_rights
      @portion = @publication.portions.find(params[:id])

	  # recalculate positions for all items before destroy
	  i = 1
	  @publication.portions.order('position').each do |p|
	    p.position = i
		p.save
		i += 1
	  end

      @portion.destroy
	  
      redirect_to journal_publication_path(@journal, @publication)
    else  
      redirect_to journal_publication_path(@journal, @publication), :flash => { :danger => t('helpers.flashes.no_delete', :default => "You have no permissions to do such action") }
    end  

  end

  def sort
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    if has_user_rights
      @portions = @publication.portions.order('position')
     
      @portions.each do |p|
        p.position = params[:portion].index(p.position.to_s)+1
        p.save
      end
    end  
    
    render :nothing => true    
  end
  
  def pdf
    @journal = Journal.find(params[:journal_id])
    @publication = @journal.publications.find(params[:publication_id])
    if has_user_rights
      @portion = @publication.portions.find(params[:portion_id])

      add_bootstrap_breadcrumb I18n.t("journals.index.title", :default => "Index"), journals_path
      add_bootstrap_breadcrumb @journal.title, journal_path(@journal)
      add_bootstrap_breadcrumb I18n.t("publications.index.title"), journal_publications_path(@journal)
      add_bootstrap_breadcrumb @publication.title, journal_publication_path(@journal, @publication)
      add_bootstrap_breadcrumb I18n.t("portions.pdf.title_pdf"), journal_publication_portion_pdf_path(@journal, @publication, @portion)
    else   
      redirect_to journal_publication_path(@journal, @publication), :flash => { :danger => t('helpers.flashes.no_create', :default => "You have no permissions to do such action") }
    end 
  end
  
  private
    def portion_params
      params.require(:portion).permit(:file, :ftype, :position, :publication_id, :pages_count, :file_pdf, :add_to_contents, :name_in_contents, :is_numbering)
  end
  
  def has_user_rights
    user_signed_in? && ((@journal.user_id == current_user.id) || (@publication.uroles.where('user_id = '+current_user.id.to_s+' AND role_id = 0').count != 0) || current_user.admin?)
  end
  
end