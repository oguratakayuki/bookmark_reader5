class AddFileIdToHistories < ActiveRecord::Migration[5.0]
  def change
    add_column :histories, :file_id, :string
  end
end
