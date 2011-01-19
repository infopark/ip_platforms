class WsController < ApplicationController

  def reset
    respond_to do |format|
      format.xml do
        Seed.reset
        head :no_content
      end
    end
  end

  def factorydefaults
    respond_to do |format|
      format.xml do
        Seed.factorydefaults
        head :no_content
      end
    end
  end

end
