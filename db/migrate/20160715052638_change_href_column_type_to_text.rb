class ChangeHrefColumnTypeToText < ActiveRecord::Migration
  def change
    change_column(:bookmarks, :href, :text)
  end
end
