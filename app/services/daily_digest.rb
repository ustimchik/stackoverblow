class Services::DailyDigest
  def send_digest
    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user, daily_questions).deliver_later
    end
  end

  private

  def daily_questions
    @daily_questions ||= Question.where(created_at: 1.day.ago..DateTime.now).to_a
  end
end