class Folder < ActiveRecord::Base
  class FolderNotFound < StandardError;end
  has_many :bookmarks, inverse_of: :folder
  belongs_to :history, inverse_of: :folders
  scope :by_layer, ->(id) { where(layer: id) }
  scope :by_path, ->(path) { where(path: path) }
  scope :by_title, ->(title) { where(title: title) }
  before_validation :initialize_by_fullpath, if:  ->(t) { t.fullpath.present? }

  validates_uniqueness_of :title,  scope: :path
  validates_presence_of :title
  attr_accessor :fullpath

  def to_s
    path.join('/')
  end
  def title_with_path
    path.to_s + '/' + title.to_s
  end
  def parent_folders
    if is_root?
      []
    else
      folders = path.split('/')
      folders.pop
      folders
    end
  end
  def is_root?
    self.path.nil? || self.path.split('/').count == 0
  end
  def has_parent?
    parent_id
  end
  def initialize_by_fullpath
    self.title, self.layer, self.path = Folder.divide_fullpath(self.fullpath.dup).values
  end
  def child_ids
    childs.pluck(:id)
  end
  def childs
    Folder.where(parent_id: id)
  end



  def update_parents 
    unless is_root?
      from_root_folder = []
      path.split('/').each do |folder|
        parent_id = Folder.find_by_fullpath(from_root_folder.dup).try(:id)
        #Folder.find_or_create_by(path: from_root_folder.join('/'), title: folder, history_id: history_id)
        from_root_folder << folder
        Folder.find_or_create_by_fullpath(from_root_folder.dup, history_id: history_id, parent_id: parent_id)
      end
      #path_array = path.split('/')
      #title = path_array.pop
      #path = path_array.join('/')

      # 自身の親を探す
      parent_id = Folder.find_by_fullpath(path).try(:id)
      update_attributes(parent_id: parent_id) if parent_id
    end
  end

  def self.find_or_create_by_fullpath(from_root_folder, option)
    puts from_root_folder
    unless folder = Folder.find_by_fullpath(from_root_folder.dup)
      hash = Folder.divide_fullpath(from_root_folder.dup)
      folder = Folder.create(hash.merge(option))
    end
    folder
  end
  def self.find_by_fullpath(from_root_path)
    title, layer, path = Folder.divide_fullpath(from_root_path).values
    #puts from_root_path
    #puts [title,layer,path]
    Folder.by_path(path).by_title(title).by_layer(layer).first
  end
  def self.divide_fullpath(from_root_path)
    ret_hash = {}
    if from_root_path.is_a?(String)
      from_root_path = from_root_path.split('/')
    end
    ret_hash[:title] = from_root_path.pop
    ret_hash[:layer] = from_root_path.size + 1
    ret_hash[:path] = from_root_path.join('/')
    #puts ret_hash
    ret_hash
  end

  #  Folder.all.order(layer: :desc).in_batches(of: 3) do |temp|
  #  end
end
