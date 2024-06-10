class PagesController < ApplicationController
  # @route GET / (root)
  def home
    @regulations = Region::REGULATIONS
  end

  # @route GET /about (about)
  def about
  end
end
