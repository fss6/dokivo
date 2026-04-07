class DashboardController < ApplicationController
  before_action :authorize_policy

  def index
    documents = Document.all
    ordered_documents = documents.order(created_at: :desc)

    @total_documents = documents.count
    @total_folders = Folder.count
    @total_users = User.count

    @recent_documents = ordered_documents.includes(:user, :folder).limit(8)
    @documents_by_type = documents
      .joins(file_attachment: :blob)
      .group("COALESCE(active_storage_blobs.content_type, 'desconhecido')")
      .order(Arel.sql("COUNT(*) DESC"))
      .count

    @total_tags, @recent_tags = tags_metrics(ordered_documents.includes(:folder).limit(100))
  end

  private

  def authorize_policy
    authorize :dashboard, :index?
  end

  def tags_metrics(recent_documents)
    all_tags = Document.pluck(:tags).flatten.compact.map(&:to_s).map(&:strip).reject(&:blank?)
    total_tags = all_tags.uniq.count

    recent_tags = recent_documents.flat_map do |document|
      document.tags.map do |tag|
        normalized_tag = tag.to_s.strip
        next if normalized_tag.blank?

        {
          name: normalized_tag,
          created_at: document.created_at,
          document: document
        }
      end
    end.compact.uniq { |entry| entry[:name].downcase }.first(10)

    [total_tags, recent_tags]
  end
end
