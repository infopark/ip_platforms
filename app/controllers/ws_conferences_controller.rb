class WsConferencesController < AbstractWsController

  def create
    conference = Conference.new(params)
    conference.creator_id = @current_user.id
    set_serie_from_params(conference)
    set_categories_from_params(conference)
    if conference.serie && !conference.serie.contacts.include?(@current_user)
      render_forbidden('no official contact for serie')
    else
      if conference.save
        render_conference(conference)
      else
        render_bad_request(conference.errors.full_messages.join(';'))
      end
    end
  end

  def show
    conference = Conference.find(params[:id])
    render_conference(conference)
  end

  def update
    conference = Conference.find(params[:id])
    conference.attributes = params
    set_serie_from_params(conference)
    if conference.serie && !conference.serie.contacts.include?(@current_user)
      render_forbidden('no official contact for serie')
    else
      if conference.save
        set_categories_from_params(conference)
        render_conference(conference)
      else
        render_bad_request(conference.errors.full_messages.join(';'))
      end
    end
  end

  private

  def set_serie_from_params(conference)
    conference.serie = Serie.find_by_name(params[:series][:name]) rescue nil
  end

  def set_categories_from_params(conference)
    if params[:categories].is_a?(Array)
      categories = params[:categories].map do |category_hash|
        Category.find_by_name(category_hash[:name]) rescue nil
      end.compact
      conference.categories = categories
    end
  end

  def render_conference(conference)
    render_ok(conference_hash(conference))
  end

end
