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

  it 'is invalid without name' do
    kid.name = ""
    expect(kid).not_to be_valid
  end

  it 'is invalid with name more than 50 letters' do
    kid.name = 'a' * 51
    expect(kid).not_to be_valid
  end

  it 'is invalid without school' do
    kid.school = ""
    expect(kid).not_to be_valid
  end

  it 'is invalid without email' do
    kid.email = " "
    expect(kid).not_to be_valid
  end

  it 'is invalid with email more than 255 letters' do
    kid.email = "a" * 244 + "@example.com"
    expect(kid).to be_invalid
  end

  it 'should have valid address' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      kid.email = valid_address
      expect(user).to be_valid
    end
  end

  it 'should not have invalid address' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      kid.email = invalid_address
      expect(kid).to be_invalid
    end
  end

  it 'is invalid without facility_id' do
    kid.facility_id = nil
    expect(kid).not_to be_valid
  end


end
