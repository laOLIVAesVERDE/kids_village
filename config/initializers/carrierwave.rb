unless Rails.env.development? || Rails.env.test?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: 'AKIAWPKMISLSS5AVDHHP',
      aws_secret_access_key: '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',
      region: 'ap-northeast-1'
    }

    config.fog_directory  = 'kidsvillage'
    config.cache_storage = :fog
  end
end
