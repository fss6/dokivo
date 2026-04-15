class MakeCompetencyItemsIndependentPerPeriod < ActiveRecord::Migration[8.0]
  def change
    add_column :competency_checklist_items, :match_terms, :jsonb, default: [], null: false
    change_column_null :competency_checklist_items, :client_checklist_item_id, true

    reversible do |dir|
      dir.up do
        execute <<~SQL
          UPDATE competency_checklist_items items
          SET match_terms = templates.match_terms
          FROM client_checklist_items templates
          WHERE templates.id = items.client_checklist_item_id
            AND (items.match_terms = '[]'::jsonb OR items.match_terms IS NULL)
        SQL
      end
    end
  end
end
