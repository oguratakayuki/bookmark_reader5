class AddBodyToBookmarks < ActiveRecord::Migration[5.0]
  def change
    add_column :bookmarks, :body, :text, after: :href
  end
end
