class Crawler
  include ActiveModel::Model
  attr_accessor :search_word, :successful, :target_url
  delegate :body, to: :investigator

  def initialize *args
    @investigated = false
    super *args
    @investigator = Investigator::Dispatcher.by_url(@target_url)
    #Bookmark.where(folder_id: 4).map(&:href).map{|t| Investigator::Dispatcher.by_url(t).body }
  end

end
