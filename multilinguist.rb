require 'httparty'
require 'json'
# require 'ap'
require 'pp'

# This class represents a world traveller who knows what languages are spoken in each country
# around the world and can cobble together a sentence in most of them (but not very well)
class Multilinguist

  TRANSLTR_BASE_URL = "http://bitmakertranslate.herokuapp.com"
  COUNTRIES_BASE_URL = "https://restcountries.eu/rest/v2/name"
  #{name}?fullText=true
  #?text=The%20total%20is%2020485&to=ja&from=en


  # Initializes the multilinguist's @current_lang to 'en'
  #
  # @return [Multilinguist] A new instance of Multilinguist
  def initialize
    @current_lang = 'en'
  end

  # Uses the RestCountries API to look up one of the languages
  # spoken in a given country
  #
  # @param country_name [String] The full name of a country
  # @return [String] A 2 letter iso639_1 language code
  def language_in(country_name)
    params = {query: {fullText: 'true'}}
    response = HTTParty.get("#{COUNTRIES_BASE_URL}/#{country_name}", params)
    json_response = JSON.parse(response.body)
    json_response.first['languages'].first['iso639_1']
  end

  # Sets @current_lang to one of the languages spoken
  # in a given country
  #
  # @param country_name [String] The full name of a country
  # @return [String] The new value of @current_lang as a 2 letter iso639_1 code
  def travel_to(country_name)
    local_lang = language_in(country_name)
    @current_lang = local_lang
  end

  # (Roughly) translates msg into @current_lang using the Transltr API
  #
  # @param msg [String] A message to be translated
  # @return [String] A rough translation of msg
  def say_in_local_language(msg)
    params = {query: {text: msg, to: @current_lang, from: 'en'}}
    response = HTTParty.get(TRANSLTR_BASE_URL, params)
    json_response = JSON.parse(response.body)
    json_response['translationText']
  end
end

class MathGenius < Multilinguist

  def report_total(list_of_numbers)
    puts say_in_local_language("The total is #{list_of_numbers.sum}.")
  end

  def report_exponential(number)
    puts say_in_local_language("e^#{number} is #{Math.exp(number)}.")
  end

end

class QuoteCollector < Multilinguist

  def initialize
    @quotes = []
  end

  def quotes
    @quotes
  end

  def add_quote(quote, topic)
    @quotes << { quote: quote, topic: topic }
  end

  def quote(quote)
    puts say_in_local_language(quote)
  end

  def quote_random(topic = nil)
    if topic
      quotes_by_topic = quotes.select { |quote| quote[:topic] == topic }
      puts say_in_local_language(quotes_by_topic[rand(quotes_by_topic.size)][:quote])
    else
      puts say_in_local_language(quotes[rand(quotes.size)][:quote])
    end
  end

end
#
# math_me = MathGenius.new
# math_me.report_exponential(15)
# math_me.travel_to("India")
# math_me.report_total([1, 2, 3, 4, 5])
# math_me.travel_to("France")
# math_me.report_total([1, 2, 3, 4, 5])
# math_me.travel_to("Iraq")
# math_me.report_total([1, 2, 3, 4, 5])
#
# quote_me = QuoteCollector.new
# quote_me.add_quote("Greatness is a choice.", "wisdom")
# quote_me.add_quote("Came out of jail went straight to the top.", "wisdom")
# quote_me.add_quote("Hello world.", "friendship")
# quote_me.add_quote("Let's get burgers!", "friendship")
# quote_me.quote("Greatness is a choice.")
# quote_me.travel_to("India")
# quote_me.quote("Greatness is a choice.")
# quote_me.travel_to("Iraq")
# quote_me.quote("Greatness is a choice.")
# quote_me.travel_to("France")
# quote_me.quote("Greatness is a choice.")
#
# ap quote_me.quotes
# pp quote_me.quotes
# quote_me.quote_random
# quote_me.quote_random("wisdom")
# quote_me.quote_random("friendship")
#
# quote_me.travel_to("India")
# quote_me.quote_random
# quote_me.quote_random("wisdom")
# quote_me.quote_random("friendship")
