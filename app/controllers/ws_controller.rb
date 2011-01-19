class WsController < AbstractWsController

  def reset
    if @current_user.admin?
      Seed.reset
      render_no_content
    else
      render_forbidden
    end
  end

  def factorydefaults
    if @current_user.admin?
      Seed.factorydefaults
      render_no_content
    else
      render_forbidden
    end
  end

end
