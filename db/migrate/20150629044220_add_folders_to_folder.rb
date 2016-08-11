class AddFoldersToFolder < ActiveRecord::Migration
  def change
    add_column :folders, :path, :string, :after => :parent_id
  end
end
