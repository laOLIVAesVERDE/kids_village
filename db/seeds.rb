# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name:  "Example User",
             email: "example@kidsvillage.com",
             password:              "password",
             password_confirmation: "password")

10.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@kidsvillage.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

users = User.order(:created_at).take(10)

facility_names = ['Kids Duo', 'Los Ninos', 'はなまる', 'Play with us', 'もとーれ']
school_names = ['本田第一小学校', '本田第二小学校', '川崎小学校', '山葉小学校']
park_names = ["大山公園", "松の木公園", "かぶと虫公園", "公園", "島田公園"]

users.each do |user|

  facility_names.each do |facility_name|
    user.facilities.create!(name: facility_name)
  end

  user.facilities.each do |facility|
    5.times do |n|
      name  = Faker::Name.name
      school = school_names.shuffle.first
      email = "example-#{n+1}@kidsvillage.com"
      introduction = "こんにちは。私の名前は" + name + "です。\n" + school + "に通っています。"
      facility.kids.create!(name:  name,
                           school: school,
                           email: email,
                           introduction: introduction)

    end

    2.times do |n|
      title = "今日の出来事"
      park = park_names.shuffle.first
      content = "今日はみんなで" + park + "に行きました。\n" + "楽しかったです。"
      facility.posts.create!(title: title, content: content)
  end
end
