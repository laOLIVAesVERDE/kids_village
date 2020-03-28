FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.free_email }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/support/test.jpg')) }
    password { password }
    password_confirmation { password }
  end
end
