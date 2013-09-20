CarrierWave.configure do |config| 
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV['AMAZON_KEY'],
    :aws_secret_access_key  => ENV['AMAZON_SECRET'],
  }
  config.fog_directory  = ENV['AMAZON_BUCKET']
end
