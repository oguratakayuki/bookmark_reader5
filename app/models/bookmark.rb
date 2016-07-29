class Bookmark < ActiveRecord::Base
  class FolderNotFound < StandardError;end
  belongs_to :folder, inverse_of: :bookmarks
  belongs_to :history, inverse_of: :bookmarks
  scope :layer_by, ->(id) { where(layer: id) }

  def folders=(value)
    super(value.to_json)
  end
  def folders
    JSON.parse(super)
  end
  def update_folder
    parent_id = Folder.where(folders: self.folders.to_json).first.id
    raise FolderNotFound unless parent_id
    update_attributes(folder_id: parent_id)
  end
  def nests
    folder.nests + 1
  end
  def full_path
    folder.folders.join('/') + '/' + title
  end
end
