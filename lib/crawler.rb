class Crawler
  include ActiveModel::Model
  attr_accessor :search_word, :successful, :target_url

  def initialize *args
    @agent = Mechanize.new
    @investigated = false
    super *args
  end

  def body
    @agent.get(@target_url)
    @agent.page.search('body').text
  end

  def find_text target_url
    @domain = target_url
    @agent.get(target_url)
    @successful = @agent.page.search('body').text.match(/#{@search_word}/)
  end

  def executable_links
    #access可能なリンク
    @agent.page.search("body").css("a").reject{|link| link['href'] =~ /javascript/  || link['href'] =~ /mailto/ }.map{|link| URI.join(@domain, link['href']).to_s.chomp('/') }
  end

end
