# frozen_string_literal: true

class EmbeddingRecord < ApplicationRecord
  belongs_to :account
  belongs_to :document, optional: true
  belongs_to :recordable, polymorphic: true

  scope :ordered_for_display, lambda {
    order(
      Arel.sql("(metadata->>'page')::integer NULLS LAST"),
      Arel.sql("(metadata->>'chunk_index')::integer NULLS LAST")
    )
  }

  validate :document_id_matches_document_recordable

  def page_number
    metadata&.fetch("page", nil)
  end

  def chunk_index
    metadata&.fetch("chunk_index", nil)
  end

  private

  def document_id_matches_document_recordable
    return unless recordable.is_a?(Document)

    expected = recordable.id
    if document_id.present? && document_id != expected
      errors.add(:document_id, "deve ser o mesmo id do recordable (documento)")
    end
  end
end
