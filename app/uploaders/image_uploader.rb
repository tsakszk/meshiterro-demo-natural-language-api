class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    'no_image.jpg'
  end

  process :fix_exif_rotation

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fit: [48, 48]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg png)
  end

  # ファイル名をランダムに
  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  # EXIF情報を削除
  def fix_exif_rotation
    manipulate! do |img|
      img.tap(&:auto_orient!)
    end
  end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, Digest::MD5.hexdigest(Time.current.to_f.to_s))
  end
end
