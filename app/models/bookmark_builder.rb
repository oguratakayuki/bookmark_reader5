module BookmarkBuilder
  class XMLImporter
    include ActiveModel::Model
    attr_accessor :result, :file
    def initialize *args
      @new_bookmark_ids = []
      @history_id = nil
      @total_counts = nil
      @result = BookmarkBuilder::Result.new
      super *args
    end

    def import
      History.transaction do
        history = History.create
        html = Markio::parse(@file.read)

        new_bookmark_ids = []
        html.each do |b|
          folders = b.folders.reject{|e | e == 'ブックマーク バー'}.uniq
          folder = Folder.find_or_create_by_fullpath(folders.join('/'), history_id: history.id)
          bookmark = Bookmark.where(href: b.href, folder_id: folder.id).first_or_initialize
          if bookmark.new_record?
            bookmark.update_attributes( title: b.title, add_date: b.add_date, history: history, layer: folder.layer.nil? ? 0 : folder.layer + 1)
          elsif bookmark.title != b.title
            #既にブックマークずみでもtitleが変更されていればtitle更新
            bookmark.update_attributes(title: b.title)
            new_bookmark_ids << bookmark.id
          end
        end

        Folder.all.order(layer: :desc).in_batches(of: 100) do |folders|
          folders.each{|folder| folder.update_parents }
        end
        @result.new_record_counts = new_bookmark_ids
        @result.history_id = history.id
      end
    end
  end

  class Result
    include ActiveModel::Model
    attr_accessor :history_id, :new_record_counts
  end
end


