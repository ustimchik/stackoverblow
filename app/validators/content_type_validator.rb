# https://gist.github.com/carlosramireziii/6d0ca6b414d8a6af08371c30ba4dedcd
class ContentTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.attached? && value.content_type.in?(content_types)
      value.purge if record.new_record? # Only purge the offending blob if the record is new
      record.errors.add(attribute, :content_type, options)
    end
  end

  private

  def content_types
    options.fetch(:in)
  end
end