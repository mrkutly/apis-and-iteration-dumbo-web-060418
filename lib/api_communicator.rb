require 'rest-client'
require 'json'
require 'pry'

def get_characters
  all_characters = RestClient.get('http://www.swapi.co/api/people/')
  character_hash = JSON.parse(all_characters)
end

def get_character_info(chars_array, char)
  chars_array["results"].find { |char_hash| char_hash["name"].downcase == char.downcase }
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
