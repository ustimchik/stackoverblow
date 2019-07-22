require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:questions) { create_list(:question, 3) }
    let(:mail) { DailyDigestMailer.digest(user, questions) }

    context 'there are new questions' do
      it "renders the headers" do
        expect(mail.subject).to eq('Questions created for the past day')
        expect(mail.to).to eq([user.email])
        expect(mail.from).to eq(["from@example.com"])
      end

      it "renders the body" do
        expect(mail.body.encoded).to match("Here are the new questions created for the past day")
      end

      it "has questions title in the body" do
        questions.each do |question|
          expect(mail.body.encoded).to have_content(question.title)
        end
      end
    end

    context 'no new questions' do
      let(:questions) { [] }

      it "renders the headers" do
        expect(mail.subject).to eq('Questions created for the past day')
        expect(mail.to).to eq([user.email])
        expect(mail.from).to eq(["from@example.com"])
      end

      it "renders the body with no new questions" do
        expect(mail.body.encoded).to match("No new questions were created for the past day")
      end
    end
  end
end
