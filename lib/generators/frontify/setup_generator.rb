module Frontify
  class SetupGenerator < Rails::Generators::Base
    source_root File.expand_path("../samples", __FILE__)

    def create_alg_components_configuration
      copy_file 'frontify.yml', "config/frontify.yml"
    end
  end
end
