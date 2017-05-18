# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  #storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id % 20}"
  end

  def default_url
   [version_name, "no-photo.png"].compact.join('-')
  end

  version :thumb do
    process :convert => 'jpg'
    process :strip
    process :resize_to_limit => [80,60]
    def full_filename (for_file = model.logo.file) 
      name = Digest::MD5.hexdigest("#{model.id}thumb")
      "thumb_#{name}.jpg"
    end
    process :quality => 95
  end

  version :thumb_m, :from_version => :large do
    process :convert => 'jpg'
    process :strip
    process :resize_to_limit => [230,200]
    def full_filename (for_file = model.logo.file) 
      name = Digest::MD5.hexdigest("#{model.id}thumb_m")
      "thumb_m_#{name}.jpg"
    end
    process :quality => 95
  end

  version :item, :from_version => :large do
    process :convert => 'jpg'
    process :resize_to_limit => [350,350]
    def full_filename (for_file = model.logo.file) 
      name = Digest::MD5.hexdigest("#{model.id}item")
      "item_#{name}.jpg"
    end 
  end

  version :large do
    process :convert => 'jpg'
    process :strip
    process :resize_to_limit => [640,750]
    process :watermark
    def full_filename (for_file = model.logo.file) 
      name = Digest::MD5.hexdigest("#{model.id}large")
      "large_#{name}.jpg"
    end 
    process :quality => 85
  end

  def watermark
    manipulate! do |img|
      water = MiniMagick::Image.open("#{Rails.root}/public/water35.png")
      img = img.composite(water, "jpg") do |c|
        c.gravity "Center"
      end
    end
  end
  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
end
