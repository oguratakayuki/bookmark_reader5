class BookmarkWorker
  include Sidekiq::Worker

  def perform(id)
    history = History.find(id)
    new_bookmark_ids = []
    failure_objects = []
    updated_bookmark_ids = []
    Bookmark.transaction do
      html = Markio::parse(history.file.read)
      new_bookmark_ids = []
      html.each do |b|
        folders = b.folders.reject{|e | e == 'ブックマーク バー'}.uniq
        folder = Folder.find_or_create_by_fullpath(folders.join('/'), history_id: history.id)
        bookmark = Bookmark.where(href: b.href, folder_id: folder.id).first_or_initialize
        if bookmark.new_record?
          bookmark.assign_attributes( title: b.title, add_date: b.add_date, history: history, layer: folder.layer.nil? ? 0 : folder.layer + 1)
          if bookmark.save
            new_bookmark_ids << bookmark.id
          else
            failure_objects << bookmark
          end
        elsif bookmark.title != b.title
          #既にブックマークずみでもtitleが変更されていればtitle更新
          bookmark.update_attributes(title: b.title)
          updated_bookmark_ids << bookmark.id
        end
      end

      Folder.all.order(layer: :desc).in_batches(of: 100) do |folders|
        folders.each{|folder| folder.update_parents }
      end
      #stream_id = "user_info_channel_#{current_user_id}"
      stream_id = "bookmark_channel"
      result = {new: new_bookmark_ids.count, updated: updated_bookmark_ids.count, failure: failure_objects.counts }
      ActionCable.server.broadcast(stream_id, result: result)
    end
  end
end
