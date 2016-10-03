class Bookmark < ActiveRecord::Base
  class FolderNotFound < StandardError;end
  belongs_to :folder, inverse_of: :bookmarks
  belongs_to :history, inverse_of: :bookmarks
  scope :layer_by, ->(id) { where(layer: id) }

  after_create :sync_body

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
  private
    def sync_body
      #urlと自身のIDを渡す
      #内部でdomainにより実行するクラスを切り替える
      #SiteWorkder.sync(id, url)
      #CrawlerWorker.perform_async id, url
      CrawlerWorker.perform_async id, href
    end
  #private end
end
