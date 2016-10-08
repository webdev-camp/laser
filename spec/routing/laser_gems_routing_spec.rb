require "rails_helper"

RSpec.describe LaserGemsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/laser_gems").to route_to("laser_gems#index")
    end

    it "routes to #new" do
      expect(:get => "/laser_gems/new").to route_to("laser_gems#new")
    end

    it "routes to #show" do
      expect(:get => "/laser_gems/1").to route_to("laser_gems#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/laser_gems/1/edit").to route_to("laser_gems#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/laser_gems").to route_to("laser_gems#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/laser_gems/1").to route_to("laser_gems#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/laser_gems/1").to route_to("laser_gems#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/laser_gems/1").to route_to("laser_gems#destroy", :id => "1")
    end

  end
end
