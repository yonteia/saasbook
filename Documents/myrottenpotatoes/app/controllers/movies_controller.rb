# This file is app/controllers/movies_controller.rb

class MoviesController < ActionController::Base
  def index
    @movies = Movie.all
  end
end
