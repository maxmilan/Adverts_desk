require "rails_helper"

RSpec.describe AdminPanelController, :type => :routing do
	describe 'admin panel routing' do
		it 'routes to #index' do
			expect(:get => "/index").to route_to("admin_panel#index")
		end
	end
end