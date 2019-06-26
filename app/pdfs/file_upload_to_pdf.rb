require 'stringio'

module FileUploadToPdf

  class IncompatibleFileTypeForMergeError < StandardError; end

  def self.combine_uploaded_files pages
    mime_type = validate_file_types pages
    merge_pages mime_type, pages
  end

  def self.validate_file_types pages
    types = pages.map {|file| file.content_type}.uniq
    raise IncompatibleFileTypeForMergeError  if types.count > 1
    return types[0]
  end

  def self.merge_pages mime_type, pages
    mime_type == "application/pdf" ? combine_pdf_pages(pages) : combine_images_as_pdf(pages)
  end

  def self.combine_pdf_pages pages
    pdf = CombinePDF.new
    pages.each do |upload|
      pdf << CombinePDF.load(upload.tempfile.path, allow_optional_content: true )

    end
    StringIO.new(pdf.to_pdf)
  end

  def self.combine_images_as_pdf pages
    doc = convert(upload_paths(pages), "test.pdf")
    return StringIO.new(doc.render)
  end

  def self.upload_paths pages
    pages.map{|upload| upload.tempfile.path}
  end

  def self.convert img_paths, name
    Prawn::Document.generate(name) do |pdf|
      img_paths.each do |img_path|
        pdf.image img_path, :fit => [pdf.bounds.right, pdf.bounds.top]
        pdf.start_new_page unless pdf.page_count == img_paths.length
      end
      return pdf
    end
  end

end
