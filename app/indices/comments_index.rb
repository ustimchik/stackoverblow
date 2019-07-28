ThinkingSphinx::Index.define :comment , with: :active_record, delta: ThinkingSphinx::Deltas::SidekiqDelta do
  #fields
  indexes body
  indexes user.email, as: :author, sortable: true

  #attributes

  has user_id, created_at, updated_at
end