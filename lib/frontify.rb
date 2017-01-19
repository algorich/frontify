require "frontify/engine"
require 'redcarpet'
require 'base64'
require 'pry-rails'

module Frontify
  class ExceptionConfiguration < StandardError; end

  class Component

    cattr_accessor :components, :section_count, :sections_html
    attr_accessor :name, :html, :navigation_section_count, :navigation_section_html, :image

    @@components = []

    class CustomRender < Redcarpet::Render::HTML
      def header(text, header_level)
        component = @options[:component]

        if header_level == 1
          component.add_navigation_section(text)
          %(<h1><a name="section-#{ component.navigation_section_count }">#{ text }</a></h1>)
        else
          %(<h#{ header_level }>#{ text }</h#{ header_level }>)
        end
      end
    end

    def self.all
      configuration_file = read_configuration_file
      components_path    = Rails.root.join('vendor', 'frontify', 'components')
      components         = configuration_file['components']
      raise Frontify::ExceptionConfiguration, "components not found" unless components.present?

      components.each do |name, value|
        path = components_path.join(name).to_s
        if File.exists?(path)
          @@components << Frontify::Component.new(name: name) unless @@components.map(&:name).include? name
        end
      end

      @@components
    end

    def self.find(name)
      all if components.empty?
      @@components.select { |component| component.name == name }[0]
    end

    def initialize(args)
      self.name = args[:name]
      self.html = ''
      self.image = ''
      self.navigation_section_html = ''
      self.navigation_section_count = 0
      self.build_data
    end

    def pretty_name
      self.name.gsub('_', ' ').capitalize
    end

    def build_data
      build_html
      set_image
    end

    def add_navigation_section(text)
      self.navigation_section_count += 1
      add_navigation_section_html(text)
    end

    def sample_by_name(sample_name)
      path = Rails.root.join('vendor', 'frontify', 'components', name, 'doc', "#{ sample_name }.html")
      File.exists?(path) ? File.open(path, 'r').read.to_s : ''
    end

    private

    def self.read_configuration_file
      config_path = Rails.root.join('config', 'frontify.yml')
      YAML.load(config_path.read)
    end

    def set_image
      base_path    = Rails.root.join('vendor', 'frontify', 'components', name)
      extensions = %w(svg png jpg jpeg gif)

      extensions.each do |extension|
        path = base_path.join("sample.#{ extension }").to_s

        if File.exists?(path)
          self.image = Base64.encode64(File.open(path, "rb").read)
          break
        end
      end
    end

    def add_navigation_section_html(text)
      self.navigation_section_html += "<a href='#section-#{ self.navigation_section_count }' class='alg-page-section'>#{ text }</a>"
    end

    def build_html
      readme_path  = Rails.root.join('vendor', 'frontify', 'components', name, 'doc', 'README.md')
      markdown     = Redcarpet::Markdown.new(Frontify::Component::CustomRender, { component: self, tables: true, fenced_code_blocks: true })
      # samples_path = Dir[base_path.to_s] - [readme_path.to_s]

      markdown_to_html(readme_path, markdown)
      samples = @html.scan(/<p><frontify-sample>(.*?)<\/frontify-sample><\/p>/).flatten.uniq
      samples.each do |sample|
        page_to_iframe(sample)
      end
    end

    def page_to_iframe(sample)
      path = Rails.root.join('vendor', 'frontify', 'components', name, 'doc', "#{ sample }.html")

      if File.exists?(path)
        content = [
          "</section>",
          "<div class='alg-viewport js-viewport'>",
            "<nav class='alg-viewport-size'>",
              "<select class='alg-viewport-size-select' data-viewport-resize>",
                "<option value=''>Select screen size</option>",
                "<option value='laptop-l'>Laptop L - 1440px</option>",
                "<option value='laptop'>Laptop - 1024px</option>",
                "<option value='tablet'>Tablet - 768px</option>",
                "<option value='mobile-l'>Mobile L - 425px</option>",
                "<option value='mobile-m'>Mobile M - 375px</option>",
                "<option value='mobile-s'>Mobile S - 320px</option>",
              "</select>",
            "</nav>",
            "<div class='alg-viewport-content'>",
              "<textarea class='alg-viewport-resize' disabled></textarea>",
              "<div class='alg-viewport-content-inner js-viewport-content'>",
                "<iframe src='#{ Frontify::Engine.routes.url_helpers.component_sample_path(name, sample) }'></iframe>",
              "</div>",
            "</div>",
          "</div>",
          "<section class='alg-container'>"
        ].join('')
        @html.gsub!("<p><frontify-sample>#{sample}</frontify-sample></p>", content)
      end
    end

    def markdown_to_html(path, markdown)
      if File.exists? path
        read_file = File.open(path, 'r').read.to_s
        content   = "<section class='alg-container markdown-body'>" + markdown.render(read_file) + '</section>'
        @html << content
      end
    end
  end
end

