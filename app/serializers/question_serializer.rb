class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :files
  has_many :answers, serializer: AnswersCollectionSerializer
  has_many :comments
  belongs_to :user
  has_many :links

  def short_title
    object.title.truncate(7)
  end

  def files
    @files = []
    object.files.each do |file|
      file_path = Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
      @files << {filename: file.filename, url: file_path}
    end
    @files
  end
end