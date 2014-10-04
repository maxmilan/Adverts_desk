require 'rails_helper'

RSpec.describe AdvertsController do
  describe "GET /adverts" do
    it "shows adverts" do
      expect(:get => adverts_path).to route_to("adverts#index")
    end
  end
end