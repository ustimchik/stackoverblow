class Link < ApplicationRecord
  before_save :set_gist

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: URI.regexp }, allow_blank: true

  default_scope { order(created_at: :asc) }

  GIST_REGEXP = /^(?:http(s)?:\/\/)?(gist.github.com\/)[\w]{1,}[\/][\w]{1,}/

  def set_gist
    self.gist = true if url.to_s.downcase.match(GIST_REGEXP)
  end

  def gist_js
    "#{self.url.to_s.downcase}.js"
  end

end