require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) {
    create(:user,
           name: 's2000',
           email: 's2000@example.com',
           password: '12242339',
           password_confirmation: '12242339',
           admin: true)
  }

  let(:facility) {
    create(:facility,
           name: 'Kids Duo',
           user_id: user.id)
  }

 let(:post) {
   create(:post,
           title: '今日の出来事',
           content: "今日はみんなでたこ焼きを食べました。\nおいしかったです。",
           facility_id: facility.id)
 }

  it 'is valid with title, content and facility_id' do
    expect(post).to be_valid
  end

  it 'is invalid without title' do
    post.title = " "
    expect(post).to be_invalid
  end

  it 'should not have title more than 50 letters' do
    post.title = "a" * 51
    expect(post).to be_invalid
  end

  it 'is invalid without content' do
    post.content = " "
    expect(post).to be_invalid
  end

  it 'should not have content more than 400 letters' do
    post.content = "a" * 403
    expect(post).to be_invalid
  end

  it 'should not have content less than 10 letters' do
    post.content = "a" * 9
    expect(post).to be_invalid
  end

  it 'is invalid without facility_id' do
    post.facility_id = nil
    expect(post).to be_invalid
  end

end
