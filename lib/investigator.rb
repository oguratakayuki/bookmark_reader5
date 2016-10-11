module Investigator
  class Dispatcher
    def self.by_url url
      url = extract_evernote_original_source_url(url) if evernote_url?(url)
      case url
      when  /evernote\.com/
        Investigator::EvernoteInvestigator.new(target_url: url)
      else
        Investigator::DefaultInvestigator.new(target_url: url)
      end
    end

    private
      def self.evernote_url? url
        url =~ /evernote\.com/
      end

      def self.extract_evernote_original_source_url url
        agent = Mechanize.new
        agent.get(url)
        agent.page.search('a#note-source-url').first.try(:[], 'href') || url
      rescue Net::OpenTimeout => e
        puts "TIMEOUT: url =#{url}"
      end
    #private end

  end
  class DefaultInvestigator
    include ActiveModel::Model
    attr_accessor :search_word, :successful, :target_url
    def initialize *args
      @agent = Mechanize.new
      @agent.redirect_ok = false
      @agent.read_timeout=3;
      @agent.open_timeout=3;
      @visited = false
      super *args
    end

    def body
      visit_only_one_time
      #@agent.get(@target_url)
      if @agent.page.present?
        @agent.page.search('body').text
      else
        'no body'
      end
    end

    def body_by_phantomjs
      require 'capybara/poltergeist'
      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 5000, js: true })
      end
      Capybara.configure do |config|
        config.ignore_hidden_elements = true
        Capybara.default_driver = :poltergeist
        Capybara.javascript_driver = :poltergeist
      end
      session = Capybara::Session.new(:poltergeist)
      session.driver.headers = {
        'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2564.97 Safari/537.36"
      }
      session.visit @target_url
      html = session.html.body.to_s
    end

    def executable_links
      #access可能なリンク
      @agent.page.search("body").css("a").reject{|link| link['href'] =~ /javascript/  || link['href'] =~ /mailto/ }.map{|link| URI.join(@target_url, link['href']).to_s.chomp('/') }
    end
    private
    def visit_only_one_time
      unless @visited
        @agent.get(@target_url)
        @visited = true
      end
    rescue Net::OpenTimeout => e
      puts "TIMEOUT: url =#{@target_url}"
    rescue SocketError => e
      puts "Socket Error: url =#{@target_url}"
    end
  end
  class EvernoteInvestigator < DefaultInvestigator
    include ActiveModel::Model
    attr_accessor :search_word, :successful, :target_url

    def body; ''; end
  end
end
