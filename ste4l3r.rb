#!/bin/ruby
require 'nokogiri'
require 'httparty'

def scraper(url)
    unparse = HTTParty.get(url)
    parse = Nokogiri::HTML(unparse.body)
    puts parse
end

scraper("https://google.com")