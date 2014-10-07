require 'rails_helper'

RSpec.describe AdvertsController, type: :routing do
  describe "adverts routing" do
    it 'routes to #index' do
      expect(:get => '/adverts').to route_to("adverts#index")
    end

	  it 'routes to #publicate' do
		  expect(:patch => '/adverts/1/publicate').to route_to("adverts#publicate", id:"1")
	  end

    it 'routes to #archivate' do
	    expect(:patch => '/adverts/1/archivate').to route_to("adverts#archivate", id:"1")
    end

    it 'routes to #accept' do
	    expect(:patch => '/adverts/1/accept').to route_to("adverts#accept", id:"1")
    end

    it 'routes to #reject' do
	    expect(:patch => '/adverts/1/reject').to route_to("adverts#reject", id:"1")
    end

    it 'routes to #reject_reason' do
	    expect(:patch => '/adverts/1/reject_reason').to route_to("adverts#reject_reason", id:"1")
    end

    it 'routes to #search' do
	    expect(:get => '/adverts/search').to route_to("adverts#search")
    end

    it 'routes to #new' do
	    expect(:get => '/adverts/new').to route_to("adverts#new")
    end

    it 'routes to #create' do
	    expect(:post => '/adverts').to route_to("adverts#create")
    end

    it 'routes to #edit' do
	    expect(:get => '/adverts/1/edit').to route_to("adverts#edit", id:"1")
    end

    it 'routes to #update' do
	    expect(:put => '/adverts/1').to route_to("adverts#update", id:"1")
    end

    it 'routes to #destroy' do
	    expect(:delete => '/adverts/1').to route_to("adverts#destroy", id:"1")
    end
  end
end