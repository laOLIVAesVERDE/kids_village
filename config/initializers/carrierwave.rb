unless Rails.env.development? || Rails.env.test?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: 'AKIAWPKMISLS43WRYOVS',
      aws_secret_access_key: '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',
      region: 'ap-northeast-1'
    }

    config.fog_directory  = 'the-power-of-dreams'
    config.cache_storage = :fog
  end
end
