@img_mime = ["image/jpg", "image/jpeg", "image/png"]
@doc_mime = ["application/pdf", "text/plain", "application/vnd.oasis.opendocument.text", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "application/x-rar-compressed", "application/zip"]
@pdf_mime = ["application/pdf"]
@img_doc_mime = @img_mime + @doc_mime
@doc_img_mime = @doc_mime + @img_mime