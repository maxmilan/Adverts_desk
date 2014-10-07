require "rails_helper"

RSpec.describe UsersController, :type => :routing do
	describe 'users routing' do
		it 'routes to #show' do
			expect(:get => "/users/1").to route_to("users#show", id:"1")
		end

		it 'routes to #destroy' do
			expect(:delete => "/users/1").to route_to("users#destroy", id:"1")
		end

		it 'routes to #finish_signup' do
			expect(:get => "/users/1/finish_signup").to route_to("users#finish_signup", id:"1")
		end

		it 'routes to #update' do
			expect(:put => "/users/1").to route_to("users#update", id:"1")
		end
	end
end