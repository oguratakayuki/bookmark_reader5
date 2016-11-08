module BookmarkImporter
  class XMLImporter
    include ActiveModel::Model
    attr_accessor :result, :file

    def import_async
      history = History.create(file: @file)
      BookmarkWorker.perform_async history.id
    end
  end
end
