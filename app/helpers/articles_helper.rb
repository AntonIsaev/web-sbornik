module ArticlesHelper

  def get_material_pages_count(article)
    material = article.materials.last
    if material.file_pdf.path.empty?
      return 0
    else  
      if material.pages_count == 0
        reader = PDF::Reader.new(material.file_pdf.path)
        material.pages_count = reader.page_count
        material.save
      end  
      return material.pages_count
    end  
  end
end
