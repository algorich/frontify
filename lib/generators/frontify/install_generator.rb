require 'safe_yaml'

module Frontify
  class ExceptionConfiguration < StandardError; end

  class InstallConfiguration
    BASE_PATH = 'vendor/frontify'
    BASE_COMPONENTS_PATH = "#{ BASE_PATH }/components"

    attr_accessor :configuration_file, :stylesheet_extensions, :javascript_extensions, :components,
      :stylesheet_file_path, :js_file_path

    def initialize
      SafeYAML::OPTIONS[:default_mode] = :safe
      SafeYAML::OPTIONS[:deserialize_symbols] = true

      self.configuration_file = read_configuration_file
      self.stylesheet_extensions = configuration_file['stylesheet_extensions'] || []
      raise Frontify::ExceptionConfiguration, "stylesheet_extensions not found" unless stylesheet_extensions.any?

      self.javascript_extensions = configuration_file['javascript_extensions'] || []
      raise Frontify::ExceptionConfiguration, "javascript_extensions not found" unless javascript_extensions.any?

      self.components = configuration_file['components']
      raise Frontify::ExceptionConfiguration, "components not found" unless components.present?

      self.stylesheet_file_path = "#{ BASE_PATH }/frontify.#{ stylesheet_extensions[0] }"
      self.js_file_path = "#{ BASE_PATH }/frontify.js"
    end

    def start
      create_components_assets
      download_components
      write_css_file
      write_js_file
    end

    def create_components_assets
      FileUtils.mkdir_p(BASE_PATH) unless File.exists?(BASE_PATH)
      FileUtils.mkdir_p(BASE_COMPONENTS_PATH) unless File.exists?(BASE_COMPONENTS_PATH)

      Dir["#{ BASE_PATH }/*"].select { |e| File.file?(e) }.each do |path|
        FileUtils.rm(path)
      end

      puts "\033[1;32m create \033[0m#{ stylesheet_file_path }\n"
      File.new(stylesheet_file_path, 'w')
      puts "\033[1;32m create \033[0m#{ js_file_path }\n"
      File.new(js_file_path, 'w')
    end

    def download_components
      components.each do |component_name, values|
        git             = values['git']
        version         = 'v' + values['version'].to_s
        component_path  = "#{ BASE_PATH }/components/#{ component_name }"
        version_path    = "#{ component_path }/.version"
        git_ignore_path = "#{ component_path }/.gitignore"
        download_new_version = false

        if git && version
          if File.exists?(version_path)
            current_version = File.open(version_path, 'r+').read
            download_new_version = current_version != version
          end

          if !File.exists?(component_path) || download_new_version
            puts "\033[1;32m cloning \033[0m#{ component_name } -version #{ version }\n"
            `rm -rf #{ component_path } > /dev/null 2>&1`
            `git clone -b #{ version } "#{ git }" "#{ component_path }" > /dev/null 2>&1`
            File.open(version_path, 'w') { |file| file.write(version); file.close }
            File.open(git_ignore_path, 'w') { |file| file.write('.version'); file.close }
          end
        end
      end
    end

    def write_css_file
      File.open(stylesheet_file_path, 'w') do |file|

        component_names = components.each do |component_name, values|
          item_path = "#{ BASE_COMPONENTS_PATH }/#{ component_name }/stylesheets/"

          stylesheet_extensions.each do |extension|
            stylesheet_extensions_path  = item_path + "base.#{ extension }"

            if File.exists? stylesheet_extensions_path
              component_content = File.open(stylesheet_extensions_path, 'r').read + "\n"
              component_content.gsub!('$$path', "components/#{ component_name }/stylesheets")
              file.write(component_content)
              break
            end
          end
        end

        file.close
      end
    end

    def write_js_file
      File.open(js_file_path, 'w') do |file|

        component_names = components.each do |component_name, values|
          item_path = "#{ BASE_COMPONENTS_PATH }/#{ component_name }/javascripts/"

          javascript_extensions.each do |extension|
            javascript_extensions_path  = item_path + "base.#{ extension }"

            if File.exists? javascript_extensions_path
              component_content = File.open(javascript_extensions_path, 'r').read + "\n"
              component_content.gsub!('$$path', "components/#{ component_name }/javascripts")
              file.write(component_content)
              break
            end
          end
        end

        file.close
      end
    end

    private

    def components
      @components ||= self.configuration_file['components']
    end

    def read_configuration_file
      config_path = Rails.root.join('config', 'frontify.yml')
      YAML.load(config_path.read)
    end
  end

  class InstallGenerator < Rails::Generators::Base
    def start
      installer = Frontify::InstallConfiguration.new
      installer.start
    end
  end
end
