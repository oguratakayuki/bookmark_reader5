module HistoryBuilder
  class Builder
    include ActiveModel::Model
    attr_accessor :history, :errors

    def read_html
      @errors = []
      History.transaction do
        @history.save
        debugger
        #html = Markio::parse(File.open @history.file.to_io)
        #html = Markio::parse(File.open @history.file.read)
        html = Markio::parse(@history.file.read)

        bookmarks = []
        target_folders = []
        html.each do |b|
          folders = b.folders.reject{|e | e == 'ブックマーク バー'}.uniq
          #formated_folder = folders.size == 1 ? folders : folders.join("/")
          folder_attributes = {folders: folders.join("/"), layer: folders.count, history: history }
          target_folders << folder = Folder.create(folder_attributes)
          bookmark_attributes = { title: b.title, href: b.href, folder_id: folder.id, layer: folders.count + 1 }
          Bookmark.create(bookmark_attributes.merge(add_date: b.add_date, history: history))
        end
        #begin
        #  target_folders = target_folders.sort_by{|t| t.folders.count}
        #  target_folders.reject{|t| t.is_root? || t.has_parent? }.each {|f| f.update_parent }
        #rescue Folder::FolderNotFound, Bookmark::FolderNotFound => e
        #  @errors << e.message
        #end
      end

    end
  end


end
