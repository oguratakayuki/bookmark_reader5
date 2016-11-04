class BookmarkBuilder
  def self.import_from_csv file
    @errors = []
    History.transaction do
      history = History.create
      html = Markio::parse(file.read)

      bookmarks = []
      target_folders = []
      html.each do |b|
        folders = b.folders.reject{|e | e == 'ブックマーク バー'}.uniq

        begin
          folder = Folder.find_or_create_by_fullpath(folders.join('/'), history_id: history.id)
        rescue => e
          debugger
        end
        bookmark_attributes = { title: b.title, href: b.href, folder_id: folder.id, layer: folder.layer.nil? ? 0 : folder.layer + 1 }

        Bookmark.create(bookmark_attributes.merge(add_date: b.add_date, history: history))
      end

      Folder.all.order(layer: :desc).in_batches(of: 100) do |folders|
        folders.each{|folder| folder.update_parents }
      end
    end

  end
end


