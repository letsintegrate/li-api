# PostgreSQL Array predicates
Ransack.configure do |config|
  %w[
    any
    all
  ].each do |p|
    config.add_predicate p, arel_predicate: p, wants_array: false
  end
end
