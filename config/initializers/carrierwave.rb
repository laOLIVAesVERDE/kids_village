if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_directory  = 'kidsvillage'
    config.cache_storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      region:  ENV['S3_REGION'],
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      # aws_access_key_id: 'AKIAWPKMISLSSPMOVRXL',
      # aws_secret_access_key: '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',
      
    }
  end
end
