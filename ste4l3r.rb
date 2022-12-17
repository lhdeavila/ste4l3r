#!/usr/bin/env ruby
require 'nokogiri'
require 'httparty'

def scraper(url)
    unparse = HTTParty.get(url)
    parse = Nokogiri::HTML(unparse.body)
    return parse
end

def main()
    parsed_site = scraper("https://www.DOMAIN/directory")

    list_first_level = parsed_site.css('a.list-group-item')
    count_first_level = list_first_level.count
    counter = 0
    id_counter = 0
    category = Array.new
    while counter <= count_first_level
        category_url = list_first_level.css('a')[counter]['href']
        get_category_list = scraper(category_url)
        # Category
        numberofproducts = get_category_list.css('span.text-primary').text
        # 50 / page
        numberofpages = numberofproducts.to_i / 50
        page = 1
        while page <= numberofpages
            page_category = scraper(category_url + "?=#{page}")
            cnt = 0
            while cnt < 50
                product = page_category.css('div.product-card')[cnt]
                features_product = product.css('ul.list-unstyled')
                product_object = {
                    id: id_counter.to_s,
                    category: list_first_level.css('a')[counter].text,
                    product_name: product.css('a.evnt')[1].text,
                    product_description: product.css('div.card-body div')[0].text,
                    features: features_product.css('li.text-truncate').text,
                    url: "https://www.DOMAIN" + product.css('div.card-header a')[0]['href']
                }
                coma = [",", ",", ",", ",", ",", " "]
                coma_counter = 0

                puts "{"
                product_object.each do |k, v|
                    valor = v.gsub("\n"," ")
                    valor = valor.gsub("  ",", ")
                    puts "\t\"#{k}\": \"#{valor}\"#{coma[coma_counter]}"
                    coma_counter += 1
                end
                puts "},"
                cnt += 1
                id_counter += 1
            end
            page += 1
        end
        counter += 1
    end
end

# Main method
main
