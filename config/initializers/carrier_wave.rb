require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

#
# CarrierWaveの初期設定
#
CarrierWave.configure do |config|
  case Rails.env
  when 'development'
    config.storage = :file
    config.permissions = 0666
    config.directory_permissions = 0777
  when 'test'
    config.storage = :file
    config.enable_processing = false
  else
    config.storage = :fog
    config.asset_host = ENV['CARRIER_WAVE_ASSET_HOST'] || "https://s3-#{ENV['AWS_REGION']}.amazonaws.com/#{ENV['AWS_S3_BUCKET_NAME']}"
    aws_credentials = {
      provider: 'AWS',
      region:   ENV['AWS_REGION'] || ''
    }

    if ENV['AWS_ACCESS_KEY'].present?
      aws_credentials[:aws_access_key_id] = ENV['AWS_ACCESS_KEY']
      aws_credentials[:aws_secret_access_key] = ENV['AWS_SECRET_KEY']
    else
      aws_credentials[:use_iam_profile] = true
    end

    config.fog_credentials = aws_credentials

    config.fog_directory  = ENV['AWS_S3_BUCKET_NAME'] || ''
    config.fog_public     = true
    config.fog_attributes = { 'Cache-Control' => 'max-age=315576000' }
  end
end
