class CrawlerWorker
  include Sidekiq::Worker
  # キュー名指定がない場合は default になる
  #sidekiq_options queue: :event

  def perform(id)
    bookmark = Bookmark.find(id)
    bookmark.update(body: Crawler.new(target_url: bookmark.href).body)
  end
end
