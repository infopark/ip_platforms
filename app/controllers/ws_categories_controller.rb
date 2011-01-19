class WsCategoriesController < AbstractWsController

  def create
    category = Category.new(params)
    parent = Category.find_by_name(params[:parent][:name]) rescue nil
    if parent
      category.parent_id = parent.id
    end
    if category.save
      render_category(category)
    else
      render_bad_request(category.errors.full_messages.join(';'))
    end
  end

  def index
    categories = Category.where(:parent_id => nil).all
    if categories.empty?
      render_no_content
    else
      render_categories(categories)
    end
  end

  def show
    category = Category.find(params[:id])
    render_category(category)
  end

  private

  def render_category(category)
    render_ok(category_hash(category))
  end

  def render_categories(categories)
    render_ok(categories.map {|category| category_hash(category, true)})
  end

end
