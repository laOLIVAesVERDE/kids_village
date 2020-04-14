require "rails_helper"

RSpec.describe PostMailer, type: :mailer do
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

  let(:post) {
    create(:post,
           title: '今日の出来事',
           content: "今日はみんなでたこ焼きパーティをしました。",
           facility_id: facility.id)
  }


  describe "create_post" do

    let(:mail) { PostMailer.create_post(kid, post.content) }

    it 'sends an email' do
      mail.deliver_now
      expect(ActionMailer::Base.deliveries.size).to eq 1
    end

    it "renders the headers" do
      expect(mail.subject).to eq("日記を書きました!")
      expect(mail.to).to eq([kid.email])
      expect(mail.from).to eq([from_email])
    end

    it "renders the body" do
      expect(mail.html_part.body).to match(kid.name + "さんが日記を書きました。")
      expect(mail.html_part.body).to match(post.content)

      expect(mail.text_part.body).to match(kid.name + "さんが日記を書きました。")
      expect(mail.text_part.body).to match(post.content)
    end
  end

end
