# frozen_string_literal: true

class Services::Search
  TYPES = %w[Question Answer User Comment].freeze

  def self.search_by(query, type = nil)
    return [] if query.blank?

    return type.constantize.search_by_full_name(query) if TYPES.include?(type)

    # ThinkingSphinx.search(query)
  end
end
