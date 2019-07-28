ThinkingSphinx::Index.define :user, with: :active_record, delta: ThinkingSphinx::Deltas::SidekiqDelta do
  #fields
  indexes email, sortable: true

  #attributes

  has created_at, updated_at
end