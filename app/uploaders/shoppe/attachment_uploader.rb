# encoding: utf-8

class Shoppe::AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include Cloudinary::CarrierWave 

  # Where should files be stored?
  def store_dir
    "attachment/#{model.id}"
  end

  # Returns true if the file is an image
  def image?(_new_file)
    # file.content_type.include? 'image'
  end

  # Returns true if the file is not an image
  def not_image?(_new_file)
    # !file.content_type.include? 'image'
  end

  # def public_id
  #   return model.short_name
  # end 

  # def store_dir
  #    "AA/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  #  end

  version :standard do
    process :eager => true
    process :resize_to_fill => [100, 150, :north]          
  end
  
  version :thumbnail do
    eager
    resize_to_fit(50, 50)
  end

  # Create different versions of your uploaded files:
  version :thumb, if: :image? do
    process resize_and_pad: [200, 200]
  end
end