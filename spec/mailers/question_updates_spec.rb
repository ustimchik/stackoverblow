require "rails_helper"

RSpec.describe QuestionUpdatesMailer, type: :mailer do
  describe "send_new_answer" do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }
    let(:mail) { QuestionUpdatesMailer.send_new_answer(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("A new answer was added")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to have_content(answer.body)
    end
  end
end