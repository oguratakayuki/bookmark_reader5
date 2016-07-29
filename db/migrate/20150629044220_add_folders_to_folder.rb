class AddFoldersToFolder < ActiveRecord::Migration
  def change
    add_column :folders, :folders, :string, :after => :parent_id
  end
end
