require "rails_helper"

RSpec.describe KidMailer, type: :mailer do
  describe "back_from_school" do
    let(:mail) { KidMailer.back_from_school }

    it "renders the headers" do
      expect(mail.subject).to eq("Back from school")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "finish_homework" do
    let(:mail) { KidMailer.finish_homework }

    it "renders the headers" do
      expect(mail.subject).to eq("Finish homework")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
