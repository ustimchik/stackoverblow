class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :twitter]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :awards, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def author_of?(item)
    item.user_id == id
  end

  def subscription_for(question)
    subscription = self.subscriptions.where(question: question)
    return subscription.first if subscription.any?
    false
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end
end
