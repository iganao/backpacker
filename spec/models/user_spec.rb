require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe '#create' do
    context '新規登録できるとき'
    it '全ての項目の入力が存在すれば登録できる' do
      expect(@user).to be_valid
    end

    it 'passwordが6文字以上であれば登録できること' do
      @user.password = 'a00000'
      @user.password_confirmation = 'a00000'
      expect(@user).to be_valid
    end
  end

  context '新規登録できないとき' do
    it 'nicknameがない場合は登録できない' do
      @user.nickname = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Nickname can't be blank")
    end

    it 'emailがない場合は登録できない' do
      @user.email = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Email can't be blank")
    end

    it '重複したemailが存在する場合登録できない' do
      @user.save
      another_user = FactoryBot.build(:user)
      another_user.email = @user.email
      another_user.valid?
      expect(another_user.errors.full_messages).to include('Email has already been taken')
    end

    it 'passwordが空では登録できない' do
      @user.password = ''
      @user.valid?
      # binding.pry
      expect(@user.errors.full_messages).to include("Password can't be blank")
    end

    it 'passwordが存在してもpassword_confirmationが空では登録できない' do
      @user.password_confirmation = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it 'passwordが5文字以下では登録できない' do
      @user.password = 'a0000'
      @user.password_confirmation = 'a0000'
      @user.valid?
      expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
    end

    it 'emailに@がない場合は登録できない' do
      @user.email = 'text'
      @user.valid?
      expect(@user.errors.full_messages).to include('Email is invalid')
    end

    it 'passwordが半角英語のみでは登録できない' do
      @user.password = 'texttext'
      @user.valid?
      expect(@user.errors.full_messages).to include('Password Please type using half-width characters')
    end

    it 'passwordが半角数字のみでは登録できない' do
      @user.password = '111111'
      @user.valid?
      expect(@user.errors.full_messages).to include('Password Please type using half-width characters')
    end

    it 'passwordが全角英数字混合では登録できない' do
      @user.password = 'TEXT１TEXT1'
      @user.valid?
      expect(@user.errors.full_messages).to include('Password Please type using half-width characters')
    end
  end
end
