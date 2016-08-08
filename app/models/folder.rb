class Folder < ActiveRecord::Base
  class FolderNotFound < StandardError;end
  has_many :bookmarks, inverse_of: :folder
  belongs_to :history, inverse_of: :folders
  scope :layer_by, ->(id) { where(layer: id) }


  #def folders=(value)
  #  super(value.to_json)
  #end
  #def folders
  #  JSON.parse(super)
  #end
  def to_s
    folders.join('/')
  end
  def title
    folders.last
  end
  def parent_folders
    if is_root?
      []
    else
      folders = folders.split('/')
      folders.pop
      folders
    end
  end
  def is_root?
    self.folders.split('/').count == 1
  end
  #def nests
  #  self.folders.count
  #end
  def has_parent?
    parent_id
  end
  def update_parent
    parent_id = Folder.where(folders: self.parent_folders.to_json).first.try(:id)
    if parent_id
      update_attributes(parent_id: parent_id)
      #raise FolderNotFound, "#{self.to_s}の親がみつかりません" 
    else
      debugger
      #親ディレクトリがなかった時
      create_parents(self.parent_folders.to_json)
      self.destroy
    end
  end
  def child_ids
    Folder.where(parent_id: id).pluck(:id)
  end
end
