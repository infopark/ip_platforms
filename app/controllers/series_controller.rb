class SeriesController < ApplicationController
  before_filter :require_current_user_is_admin, :except => [:index, :show]

  def index
    @series = Serie.all

    respond_to do |format|
      format.html
      format.xml  { render :xml => @series }
    end
  end

  def show
    @serie = Serie.find(params[:id])
    respond_to do |format|
      format.html
      format.xml  { render :xml => @serie }
    end
  end

  def new
    @serie = Serie.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @serie }
    end
  end

  def edit
    @serie = Serie.find(params[:id])
  end

  def create
    @serie = Serie.new(params[:serie])

    respond_to do |format|
      if @serie.save
        format.html { redirect_to(series_path, :notice => 'Serie was successfully created.') }
        format.xml  { render :xml => @serie, :status => :created, :location => @serie }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @serie.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @serie = Serie.find(params[:id])

    respond_to do |format|
      if @serie.update_attributes(params[:serie])
        format.html { redirect_to(series_path, :notice => 'Serie was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @serie.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @serie = Serie.find(params[:id])
    @serie.destroy

    respond_to do |format|
      format.html { redirect_to(series_url) }
      format.xml  { head :ok }
    end
  end
end
