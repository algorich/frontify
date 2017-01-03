module Frontify::Components
  class SamplesController < Frontify::ApplicationController
    layout 'frontify/samples'
    def show
      @content = Frontify::Component.find(params[:component_id]).sample_by_name(params[:id]).html_safe
    end
  end
end
