class Bookmark < ActiveRecord::Base
  class FolderNotFound < StandardError;end
  belongs_to :folder, inverse_of: :bookmarks
  belongs_to :history, inverse_of: :bookmarks
  scope :layer_by, ->(id) { where(layer: id) }
  scope :href_like, ->(href) { where(arel_table[:href].matches("%#{href}%")) }

  #create時に件数が多い時は実行せずにアクセスされると実行するようにする
  #after_create :sync_body

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

  def self.top_ten
    all.map{|t| URI(t.href).host rescue '' }.group_by{|t| t}.map{|t| {domain: t.first, size: t.second.count} }.sort_by{|t| t[:size]}
    #{:domain=>"www.evernote.com", :size=>409}]
    #{:domain=>"qiita.com", :size=>136},
    #{:domain=>"d.hatena.ne.jp", :size=>64},
    #{:domain=>"stackoverflow.com", :size=>47},
    #{:domain=>"dev.classmethod.jp", :size=>31},
    #{:domain=>"tabelog.com", :size=>29},
    #{:domain=>"coliss.com", :size=>24},
    #{:domain=>"github.com", :size=>22},
    #{:domain=>"liginc.co.jp", :size=>20},
    #{:domain=>"cookpad.com", :size=>15},
    #{:domain=>"www.atmarkit.co.jp", :size=>14},
    #{:domain=>"s.tabelog.com", :size=>13},
    #{:domain=>"www.infoq.com", :size=>13},
    #{:domain=>"postd.cc", :size=>13},
    #{:domain=>"morizyun.github.io", :size=>12},
    #{:domain=>"matome.naver.jp", :size=>11},
  end

  private
    def sync_body
      #urlと自身のIDを渡す
      #内部でdomainにより実行するクラスを切り替える
      CrawlerWorker.perform_async id
    end
  #private end

end
