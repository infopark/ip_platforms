require 'spec_helper'

describe HomeController do
  render_views

  describe "#index" do
    it "render a localized hello message" do
      get :index
      response.body.should include("Hello world")
    end
  end
end
