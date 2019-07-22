class DailyDigestJob < ApplicationJob
  queue_as :mailers

  def perform
    Services::DailyDigest.new.send_digest
  end
end
