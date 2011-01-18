require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe SeriesController do

  def mock_serie(stubs={})
    @mock_serie ||= mock_model(Serie, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all series as @series" do
      Serie.stub(:all) { [mock_serie] }
      get :index
      assigns(:series).should eq([mock_serie])
    end
  end

  describe "GET show" do
    it "assigns the requested serie as @serie" do
      Serie.stub(:find).with("37") { mock_serie }
      get :show, :id => "37"
      assigns(:serie).should be(mock_serie)
    end
  end

  describe "GET new" do
    it "assigns a new serie as @serie" do
      Serie.stub(:new) { mock_serie }
      get :new
      assigns(:serie).should be(mock_serie)
    end
  end

  describe "GET edit" do
    it "assigns the requested serie as @serie" do
      Serie.stub(:find).with("37") { mock_serie }
      get :edit, :id => "37"
      assigns(:serie).should be(mock_serie)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created serie as @serie" do
        Serie.stub(:new).with({'these' => 'params'}) { mock_serie(:save => true) }
        post :create, :serie => {'these' => 'params'}
        assigns(:serie).should be(mock_serie)
      end

      it "redirects to the created serie" do
        Serie.stub(:new) { mock_serie(:save => true) }
        post :create, :serie => {}
        response.should redirect_to(serie_url(mock_serie))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved serie as @serie" do
        Serie.stub(:new).with({'these' => 'params'}) { mock_serie(:save => false) }
        post :create, :serie => {'these' => 'params'}
        assigns(:serie).should be(mock_serie)
      end

      it "re-renders the 'new' template" do
        Serie.stub(:new) { mock_serie(:save => false) }
        post :create, :serie => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested serie" do
        Serie.stub(:find).with("37") { mock_serie }
        mock_serie.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :serie => {'these' => 'params'}
      end

      it "assigns the requested serie as @serie" do
        Serie.stub(:find) { mock_serie(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:serie).should be(mock_serie)
      end

      it "redirects to the serie" do
        Serie.stub(:find) { mock_serie(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(serie_url(mock_serie))
      end
    end

    describe "with invalid params" do
      it "assigns the serie as @serie" do
        Serie.stub(:find) { mock_serie(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:serie).should be(mock_serie)
      end

      it "re-renders the 'edit' template" do
        Serie.stub(:find) { mock_serie(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested serie" do
      Serie.stub(:find).with("37") { mock_serie }
      mock_serie.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the series list" do
      Serie.stub(:find) { mock_serie }
      delete :destroy, :id => "1"
      response.should redirect_to(series_url)
    end
  end

end