class CrawlerWorker
  include Sidekiq::Worker
  # キュー名指定がない場合は default になる
  #sidekiq_options queue: :event

  #def perform(id, url)
  def perform(id)
    #Bookmark.first.update(body: Time.now.to_s)
    bookmark = Bookmark.find(id)
    bookmark.update(body: Crawler.new(target_url: bookmark.href).body)
    #Bookmark.find(id).update(body: Crawler.new(url).summarize_body)
    require 'capybara/poltergeist'

    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 5000, js: true })
    end
    session = Capybara::Session.new(:poltergeist)
    session.driver.headers = {
      'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2564.97 Safari/537.36"
    }
    session.visit "http://www.yahoo.co.jp"
    html = session.html.to_s
    bookmark.update(body: html)




  end
end
