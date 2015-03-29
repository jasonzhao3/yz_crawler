require 'net/http'
require 'uri'
require 'open-uri'
require 'rubygems'
require 'hpricot'
require './url_utils'

class Spider
  include UrlUtils
  
  def initialize
    @already_visited = {}
  end

  def crawl_web(urls, depth=2, page_limit = 100)
    depth.times do
      next_urls = []
      urls.each do |url|
        url_object = open_url(url)
        next if url_object.nil?

        url = update_url_if_redirected(url_object)
        parsed_doc = parse_url(url_object)
        next if parsed_doc.nil?

        @already_visited[url] = true if @already_visited[url].nil?
        return if @already_visited.size == page_limit

        next_urls += (find_urls_on_page(parsed_doc, url) - @already_visited.keys)
        next_urls.uniq!
      end
      urls = next_urls
    end
  end

  def crawl_domain(url, page_limit = 100)
    return if @already_visited.size == page_limit

    url_object = open_url(url)
    return if url_object.nil?

    parsed_doc = parse_url(url_object)
    return if parsed_doc.nil?

    @already_visited[url] = true if @already_visited[url].nil?
    page_urls = find_urls_on_page(parsed_doc, url)
    page_urls.each do |page_url|
      if urls_on_same_domain?(url, page_url) && @already_visited[page_url].nil?
        crawl_domain(page_url)
      end
    end
  end

  private
  
  def open_url(url)
    open(url)
  rescue
    puts "Unable to open url: " + url
  end

  def update_url_if_redirected(url_object)
    url_object.base_uri.to_s
  end

  def parse_url(url_object)
    doc = Hpricot(url_object)
    puts 'Crawling url ' + url_object.base_uri.to_s
    doc
  rescue
    puts 'Could not parse url: ' + url_object.base_uri.to_s
  end

  def find_urls_on_page(parsed_doc, current_url)
    parsed_doc.search('a[@href]').each_with_object([]) do |x, urls_list|
      new_url = x['href'].split('#')[0]
      if new_url
        # complicated feature: make_absolute
        new_url = make_absolute(current_url, new_url) if relative?(new_url)
        urls_list.push(new_url)
      end
    end
  end
end