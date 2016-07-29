class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.string :title
      t.string :href
      t.date :add_date
      t.references :folder, index: true
      t.references :history, index: true

      t.timestamps null: false
    end
  end
end
