require 'rails_helper'

RSpec.describe User, type: :model do
  #有効なファクトリをもつこと
  it "has a valid factory" do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  # 名がなければ無効な状態である
  it "is invalid without a first name" do
    user = FactoryGirl.build(:user, first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  # 姓がなければ無効な状態である
  it "is invlid without a last name" do
    user = FactoryGirl.build(:user, last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  # メールアドレスがなければ無効な状態である
  it "is invalid without an email address" do
    user = FactoryGirl.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  # 重複したメールあどれすならば無効な状態である
  it "is invalid with a duplicate email address" do
    FactoryGirl.create(:user, email: "aaron@exapme.com")
    user = FactoryGirl.build(:user, email: "aaron@exapme.com")
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end


  # ユーザーのフルネームを文字列として返す
  it "returns a user's full name as a string" do
    user = FactoryGirl.build(:user, first_name: "Jonh", last_name: "Doe")
    expect(user.name).to eq "Jonh Doe"
  end
end
