module Frontify
  class SetupGenerator < Rails::Generators::Base
    source_root File.expand_path("../samples", __FILE__)

    def create_alg_components_configuration
      copy_file 'frontify.yml', "config/frontify.yml"
      inject_into_file 'config/routes.rb', after: "Rails.application.routes.draw do\n" do
        "  mount Frontify::Engine => '/frontify'\n"
      end
      inject_into_file 'config/initializers/assets.rb', before: "Rails.application.config.assets.version" do
        "Rails.application.config.assets.paths << 'vendor/frontify/'\n"
      end
    end
  end
end
