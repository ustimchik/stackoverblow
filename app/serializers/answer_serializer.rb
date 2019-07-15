class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :files
  belongs_to :user
  belongs_to :question
  has_many :links
  has_many :comments

  def files
    @files = []
    object.files.each do |file|
      file_path = Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
      @files << {filename: file.filename, url: file_path}
    end
    @files
  end
end