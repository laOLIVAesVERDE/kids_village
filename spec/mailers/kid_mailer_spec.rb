require "rails_helper"

RSpec.describe KidMailer, type: :mailer do
  let(:from_email) {
    'noreply@kidsvillage.com'
  }

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


  describe "back_from_school" do

    let(:mail) { KidMailer.back_from_school(kid) }

    it 'sends an email' do
      mail.deliver_now
      expect(ActionMailer::Base.deliveries.size).to eq 1
    end

    it "renders the headers" do
      expect(mail.subject).to eq("学校から戻りました!")
      expect(mail.to).to eq([kid.email])
      expect(mail.from).to eq([from_email])
    end

    it "renders the body" do
      expect(mail.html_part.body).to match(kid.name + "さん@" + kid.facility.name + "からのメッセージです。")
      expect(mail.html_part.body).to match("学校から戻りました!")

      expect(mail.text_part.body).to match(kid.name + "さん@" + kid.facility.name + "からのメッセージです。")
      expect(mail.text_part.body).to match("学校から戻りました!")
    end
  end

  describe "finish_homework" do
    let(:mail) { KidMailer.finish_homework(kid) }

    it 'sends an email' do
      mail.deliver_now
      expect(ActionMailer::Base.deliveries.size).to eq 1
    end

    it "renders the headers" do
      expect(mail.subject).to eq("宿題が終わりました!")
      expect(mail.to).to eq([kid.email])
      expect(mail.from).to eq([from_email])
    end

    it "renders the body" do
      expect(mail.html_part.body).to match(kid.name + "さん@" + kid.facility.name + "からのメッセージです。")
      expect(mail.html_part.body).to match("今日の宿題が終わりました!")

      expect(mail.text_part.body).to match(kid.name + "さん@" + kid.facility.name + "からのメッセージです。")
      expect(mail.text_part.body).to match("今日の宿題が終わりました!")
    end
  end

end
