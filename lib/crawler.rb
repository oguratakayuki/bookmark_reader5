class Crawler
  include ActiveModel::Model
  attr_accessor :search_word, :successful, :target_url
  delegate :body, to: :investigator

  def initialize *args
    @investigated = false
    super *args
    @investigator = Crawler::InvestigatorDispatcher.by_url(@target_url)
  end

end
