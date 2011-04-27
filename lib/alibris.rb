require 'rubygems'
require 'hashie'
require 'httparty'

module Alibris
  class Search
    include HTTParty
    base_uri 'api.alibris.com/v1/public/search/'
    format :json

    def initialize(options = {})
      @api_key = options[:api_key]           # required
      @output_type = options[:output_type]   # optional, valid values ['json', 'xml'], defaults to xml
      @num_results = options[:num_results]   # optional, number of results returned, defaults to 25
    end

    def works(search_term=nil, author=nil, title=nil, topic=nil, options={})
      if @api_key.nil?
        # TODO: Create a custom exception
        raise Exception.new("An API Key is required to use the Alibris API. Get a key from http://developer.alibris.com")
      end
      if (author.nil? && title.nil? && topic.nil? && search_term.nil?)
        raise Exception.new("You either need to pass an author, a title, a topic or a search term, to perform searches.")
      end
      path = "/"
      options.merge!({:apikey => @api_key}) unless @api_key.nil?
      options.merge!({:outputtype => @output_type}) unless @output_type.nil?
      options.merge!({:wauth => author}) unless author.nil?
      options.merge!({:wtit => title}) unless title.nil?
      options.merge!({:wtopic => topic}) unless topic.nil?
      options.merge!({:wquery => search_term}) unless search_term.nil?
      options.merge!({:chunk => @num_results}) unless @num_results.nil?
      Hashie::Mash.new Alibris::Search.get(path, :query => options)
    end
    def books(search_term=nil, author=nil, title=nil, topic=nil, options={})
      opts = options.merge({:mtype => 'B'})
      works(search_term, author, title, topic, opts)
    end
    def books_by_author(author, options={})
      books(nil, author, nil, nil, options)
    end
    def books_by_title(title, options={})
      books(nil, nil, title, nil, options)
    end
    def books_by_topic(topic, options={})
      books(nil, nil, nil, topic, options)
    end
    def music(search_term=nil, author=nil, title=nil, topic=nil, options={})
      opts = options.merge({:mtype => 'M'})
      works(search_term, author, title, topic, opts)
    end
    def music_by_author(author, options={})
      music(nil, author, nil, nil, options)
    end
    def music_by_title(title, options={})
      music(nil, nil, title, nil, options)
    end
    def music_by_topic(topic, options={})
      music(nil, nil, nil, topic, options)
    end
    def videos(search_term=nil, author=nil, title=nil, topic=nil, options={})
      opts = options.merge({:mtype => 'V'})
      works(search_term, author, title, topic, opts)
    end
    def videos_by_author(author, options={})
      videos(nil, author, nil, nil, options)
    end
    def videos_by_title(title, options={})
      videos(nil, nil, title, nil, options)
    end
    def videos_by_topic(topic, options={})
      videos(nil, nil, nil, topic, options)
    end
  end
end