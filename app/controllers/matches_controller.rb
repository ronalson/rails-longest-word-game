class MatchesController < ApplicationController

  def new
    @grid = generate_grid(10)
    @start_time = Time.now
  end

  def show
    @grid = params[:grid]
    @guess = params[:guess]
    @start_time = params[:start_time]
    @end_time = Time.now
    @time_taken = @end_time - @start_time.to_datetime
    @score = compute_score(@guess, @time_taken)
    @message = message(@guess, @grid)
  end

  private
  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end

  def message(attempt, grid)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        return "well done"
      else
        @score = 0
        return "not a english_word"
      end
    else
      @score = 0
      return "not in the grid"
    end
  end
end
