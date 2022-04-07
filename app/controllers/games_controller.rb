require 'json'
require 'open-uri'
class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    url = "https://wagon-dictionary.herokuapp.com/#{params[:attempt]}"
    @answer = JSON.parse(URI.open(url).read)
    @attempt_array = params[:attempt].chars
    @correctness = true

    @letters_chomp = params[:letters].strip.chars
    @attempt_array.each do |a|
      if @letters_chomp.include?(a.upcase)
        @letters_chomp.delete_at(@letters_chomp.index(a.upcase))
      else
        @correctness = false
      end
    end

    @message = ''
    if @correctness
      if @answer['found']
        @message = "Congratulations! #{params[:attempt]} is a valid English word!"
      else
        @message = "Sorry but #{params[:attempt]} does not seem to be a valid English word..."
      end
    else
      @message = "Sorry but #{params[:attempt]} can't be built from the given letters."
    end
    @message
  end
end
