module Frontify
  class ComponentsController < Frontify::ApplicationController
    def index
    end

    def show
      @component = Frontify::Component.find(params[:id])
    end
  end
end