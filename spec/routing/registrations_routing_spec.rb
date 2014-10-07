require "rails_helper"

RSpec.describe RegistrationsController, :type => :routing do
	describe 'registrations routing' do
		it 'routes to #cancel' do
			expect(:get => "/users/cancel").to route_to("registrations#cancel")
		end

		it 'routes to #create' do
			expect(:post => "/users").to route_to("registrations#create")
		end

		it 'routes to #new' do
			expect(:get => "/users/sign_up").to route_to("registrations#new")
		end
	end
end