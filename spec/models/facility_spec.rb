require 'rails_helper'

RSpec.describe Facility, type: :model do
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

  it 'is valid with name and user id' do
    expect(facility).to be_valid
  end

  it 'is invalid without name' do
    facility.name = ' '
    expect(facility).to be_invalid
  end

  it 'is invalid with name more than 50 letters' do
    facility.name = 'a' * 51
    expect(facility).to be_invalid
  end

  it 'is invalid without user id' do
    facility.user_id = nil
    expect(facility).to be_invalid
  end
end
