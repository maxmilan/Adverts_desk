require "rails_helper"

RSpec.describe PersonsController, :type => :routing do
	describe 'persons routing' do
		it 'routes to #profile' do
			expect(:get => "/profile").to route_to("persons#profile")
		end
	end
end