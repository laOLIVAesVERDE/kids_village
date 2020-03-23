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

  it 'is valid with name and user id' do
    facility = user.facilities.build(name: 'Kids Duo')
    expect(facility).to be_valid
  end

  it 'is invalid without name' do
    facility = user.facilities.build(name: '')
    expect(facility).to be_invalid
  end

  it 'is invalid with name more than 50 letters' do
    facility = user.facilities.build(name: 'a' * 51)
    expect(facility).to be_invalid
  end

  it 'is invalid without user id' do
    facility = user.facilities.build(name: 'Kids Duo')
    facility.user_id = nil
    expect(facility).to be_invalid
  end

end
