module Frontify
  class ComponentsController < Frontify::ApplicationController
    def index
    end

    def show
      @component = Frontify::Component.find(params[:id])

      respond_to do |format|
        format.js
        format.html
      end
    end
  end
end
