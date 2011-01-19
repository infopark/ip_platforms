class WsSeriesController < AbstractWsController

  def create
    serie = Serie.new(params)
    if serie.save
      render_serie(serie)
    else
      render_bad_request(serie.errors.full_messages.join(';'))
    end
  end

  def index
    series = Serie.all
    if series.empty?
      render_no_content
    else
      render_series(series)
    end
  end

  def show
    serie = Serie.find(params[:id])
    render_serie(serie)
  end

  def update
    serie = Serie.find(params[:id])
    serie.attributes = params
    if serie.save
      render_serie(serie)
    else
      render_bad_request(serie.errors.full_messages.join(';'))
    end
  end

  private

  def render_serie(serie)
    render_ok(serie_hash(serie))
  end

  def render_series(series)
    render_ok(series.map {|serie| serie_hash(serie, true)})
  end

end
