require 'rails_helper'

describe Contact do
  it '姓と名とメールアドレスがあれば有効な状態であること' do
    contact = Contact.new(
      firstname: 'Aaron',
      lastname: 'Sumner',
      email: 'tester@example.com')
    expect(contact).to be_valid
  end

  it '姓がなければ無効な状態であること' do
    contact = Contact.new(firstname: nil)
    contact.valid?
    expect(contact.errors[:firstname]).to include("can't be blank")
  end

  it '名がなければ無効な状態であること' do
    contact = Contact.new(lastname: nil)
    contact.valid?
    expect(contact.errors[:lastname]).to include("can't be blank")
  end

  it 'メールアドレスが登録されていなければ無効な状態であること' do
    contact = Contact.new(email: nil)
    contact.valid?
    expect(contact.errors[:email]).to include("can't be blank")
  end

  it 'メールアドレスが重複する場合は無効な状態であること' do
    Contact.create(
      firstname: 'Joe', lastname: 'Tester',
      email: 'tester@example.com'
    )
    contact = Contact.new(
      firstname: 'Jane', lastname: 'Tester',
      email: 'tester@example.com'
    )
    contact.valid?
    expect(contact.errors[:email]).to include("has already been taken")
  end

  it '連絡先のフルネームを文字列として返すこと' do
    contact = Contact.new(
      firstname: 'John',
      lastname: 'Doe',
      email: 'johndoe@example.com'
    )
    expect(contact.name).to eq 'John Doe'
  end

  describe '名前を文字で検索する' do
    before :each do
      @smith = Contact.create(
        firstname: 'John',
        lastname: 'Smith',
        email: 'jsmith@example.com'
      )
      @jones = Contact.create(
        firstname: 'Tim',
        lastname: 'Jones',
        email: 'tjones@example.com'
      )
      @johnson = Contact.create(
        firstname: 'John',
        lastname: 'Johnson',
        email: 'jjohnson@example.com'
      )
    end

    context '文字がマッチングするときとき' do
      it 'マッチした結果をソート済みの配列として返すこと' do
        expect(Contact.by_letter('J')).to eq [@johnson, @jones]
      end
    end

    context '文字がマッチしないとき' do
      it 'マッチしない結果は含まれないこと' do
        expect(Contact.by_letter('J')).not_to include @smith
      end
    end
  end
end
