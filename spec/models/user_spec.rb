require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  it 'is valid with name and email' do
    expect(@user).to be_valid
  end

  it 'is invalid without name' do
    @user.name = ""
    expect(@user).to be_invalid
  end

  it 'is invalid without email' do
    @user.email = ""
    expect(@user).to be_invalid
  end

  it 'is invalid with name more than 50 letters' do
    @user.name = "a" * 51
    expect(@user).to be_invalid
  end

  it 'is invalid with email more than 255 letters' do
    @user.email = "a" * 244 + "@example.com"
    expect(@user).to be_invalid
  end

  it 'should have valid address' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      expect(@user).to be_valid
    end
  end

  it 'should not have invalid address' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      expect(@user).to be_invalid
    end
  end

  it 'should have unique address' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    expect(duplicate_user).to be_invalid
  end

  it 'should have address saved as lower-case' do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    expect(@user.email).not_to eq mixed_case_email
  end

  it 'is valid with password' do
    @user.password = @user.password_confirmation = " " * 6
    expect(@user).not_to be_valid
  end

  it 'has password more than 6 letters' do
    @user.password = @user.password_confirmation = "a" * 5
    expect(@user).not_to be_valid
  end
end
