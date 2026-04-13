# frozen_string_literal: true

class AddClientIdToFolders < ActiveRecord::Migration[8.0]
  def change
    add_reference :folders, :client, foreign_key: true
  end
end
