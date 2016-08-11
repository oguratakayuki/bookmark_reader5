class AddLayerToFolderAndBookmark < ActiveRecord::Migration
  def change
    add_column :folders, :layer, :integer, :after => :path
    add_column :bookmarks, :layer, :integer, :after => :folder_id
  end
end
