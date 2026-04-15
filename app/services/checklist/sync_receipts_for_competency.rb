module Checklist
  class SyncReceiptsForCompetency
    def initialize(checklist:)
      @checklist = checklist
    end

    def call
      @checklist.items.includes(:client_checklist_item).find_each do |item|
        sync_item!(item)
      end
    end

    private

    def sync_item!(item)
      matched_document = find_matching_document(item)
      return if matched_document.blank?
      return if item.validated?

      item.update!(
        state: :received,
        received_at: item.received_at || Time.current,
        last_document: matched_document
      )
    end

    def find_matching_document(item)
      # Backward compatible with older checklist items linked to client templates.
      raw_terms = item.match_terms.presence || item.client_checklist_item&.match_terms
      terms = Array(raw_terms).map { |term| term.to_s.downcase.strip }.reject(&:blank?).uniq
      return nil if terms.empty?

      documents_for_period.detect do |document|
        searchable_text = [document.file.filename.to_s, document.content, document.summary, document.tags.join(" ")].compact.join(" ").downcase
        terms.any? { |term| searchable_text.include?(term) }
      end
    end

    def documents_for_period
      @documents_for_period ||= begin
        start_at = @checklist.period.beginning_of_month.beginning_of_day
        end_at = @checklist.period.end_of_month.end_of_day

        @checklist.account.documents
          .joins(:folder)
          .where(folders: { client_id: @checklist.client_id })
          .where(created_at: start_at..end_at)
          .with_attached_file
          .order(created_at: :desc)
      end
    end
  end
end
