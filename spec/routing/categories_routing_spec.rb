require "rails_helper"

RSpec.describe CategoriesController, :type => :routing do
  describe 'categories routing' do
    it 'routes to #new' do
      expect(:get => "/categories/new").to route_to("categories#new")
    end

    it 'routes to #create' do
	    expect(:post => "/categories").to route_to("categories#create")
    end

	  it 'routes to #destroy' do
		  expect(:delete => "/categories/1").to route_to("categories#destroy", id:"1")
	  end
  end
end