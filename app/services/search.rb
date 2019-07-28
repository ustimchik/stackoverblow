class Services::Search
  CATEGORIES = %w[All Question Answer Comment User]

  def perform(query, category)
    return if escaped(query).nil? || @escaped.empty?
    if category == 'All'
      ThinkingSphinx.search(@escaped)
    elsif CATEGORIES.include?(category)
      category.capitalize.constantize.search(@escaped)
    end
  end

  private

  def escaped(query)
    @escaped ||= ThinkingSphinx::Query.escape(query) unless query.nil?
  end
end