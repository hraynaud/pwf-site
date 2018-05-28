# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  include CarrierWaveDirect::Uploader

  process :set_content_type
  
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{model.class.to_s.pluralize.underscore}/profile_pictures/#{model.name.parameterize}-#{model.id}"
  end

   def default_url
    "/images/" + [:thumb, "missing.png"].compact.join('_')
  end

  version :thumb do
    process :resize_to_fit => [100, 150]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{model.name.parameterize.underscore}.#{file.extension}"  if original_filename
  end

end
