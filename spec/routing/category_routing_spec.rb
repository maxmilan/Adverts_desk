require "rails_helper"

RSpec.describe CategoriesController, :type => :routing do
  describe 'categories routing' do
    it 'routes to #new' do
      expect(:get => "/categories/new").to route_to("categories#new")
    end
  end
end