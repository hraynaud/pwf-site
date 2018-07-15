# encoding: utf-8

class TranscriptUploader < CarrierWave::Uploader::Base
  include CarrierWaveDirect::Uploader

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "students/report_cards/#{model.student_name.parameterize}-#{model.student_id}"
  end



  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  #def extension_white_list
    #%w(pdf)
  #end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.

  def filename
    "#{model.student_name.parameterize.underscore}.#{file.extension}"  if original_filename
  end
end
