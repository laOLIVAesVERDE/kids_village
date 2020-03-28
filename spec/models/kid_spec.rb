require 'rails_helper'

RSpec.describe Kid, type: :model do
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

 let(:kid) {
   create(:kid,
           name: '本田　太郎',
           school: '第一小学校',
           email: 'honda_taro@kidsvillage.com',
           introduction: 'こんにちは！',
           facility_id: facility.id)
 }

  it 'is invalid with name' do
    kid.name = ""
    expect(kid).not_to be_valid
  end




end
