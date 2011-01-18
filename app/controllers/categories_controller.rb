class CategoriesController < ApplicationController
  before_filter :require_current_user_is_admin, :except => :index

  # GET /categories
  # GET /categories.xml
  def index
    @categories = Category.order(:name).all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new
    load_potential_parents

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
    load_potential_parents
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:category])
    load_potential_parents

    respond_to do |format|
      if @category.save
        format.html { redirect_to(categories_path :notice => 'Category was successfully created.') }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])
    load_potential_parents

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to(categories_path, :notice => 'Category was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @category = Category.find(params[:id])
    respond_to do |format|
      format.html do
        if @category.children.any?
          redirect_to categories_path, :notice => "Category is not empty!"
        else
          @category.destroy
          redirect_to(categories_url, :notice => 'Category has been deleted.')
        end
      end
    end
  end

  private

  def load_potential_parents
    @categories = Category.all
    @categories.delete(@category)
    @categories -= @category.children
  end
end
