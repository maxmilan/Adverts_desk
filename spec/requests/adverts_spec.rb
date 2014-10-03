require 'rails_helper'

describe "Adverts" do
  describe "GET /adverts" do
    it "shows adverts" do
      get adverts_path
      response.status.should be(200)
    end
  end
end