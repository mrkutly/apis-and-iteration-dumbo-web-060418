require 'rest-client'
require 'json'
require 'pry'

def get_characters
  array = []
  x = 1

  loop do
    url = "https://www.swapi.co/api/people/?page=#{x}"
    page = RestClient.get(url)
    hash = JSON.parse(page)
    array << hash
    x += 1
    break if !hash["next"]
  end
  
  pages = array.flatten
end

def get_character_info(pages_array, char)
  pages_array.map do |page_hash|
    page_hash["results"].map do |char_hash|
      if char_hash["name"].downcase == char.downcase
        return char_hash
      end
    end
  end
end

def get_film_urls(character_info)
  character_info["films"].map do |url|
    string = RestClient.get(url)
    JSON.parse(string)
  end
end

def get_character_movies_from_api(character)
  characters = get_characters
  character_info = get_character_info(characters, character)
  get_film_urls(character_info)
end

def parse_character_movies(films_hash)
  films_hash.each do |hash|
    puts "================================"
    puts "#{hash["title"]} (#{hash["release_date"].slice(0, 4)})"
    puts "================================"
  end
end

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  parse_character_movies(films_hash)
end
