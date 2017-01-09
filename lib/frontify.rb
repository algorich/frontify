require "frontify/engine"
require 'redcarpet'
require 'pry-rails'

module Frontify
  class Component
    cattr_accessor :components, :section_count, :sections_html
    attr_accessor :name, :html, :navigation_section_count, :navigation_section_html

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
      components_path = Rails.root.join('vendor', 'frontify', 'components', '*')
      component_names  = Dir[components_path.to_s].map { |item| item.split('components/')[-1] }.sort
      component_names.each { |name| @@components << Frontify::Component.new(name: name) unless @@components.map(&:name).include? name }
      @@components
    end

    def self.find(name)
      all if components.empty?
      @@components.select { |component| component.name == name }[0]
    end

    def initialize(args)
      self.name = args[:name]
      self.html = ''
      self.navigation_section_html = ''
      self.navigation_section_count = 0
      self.build_data
    end

    def pretty_name
      self.name.gsub('_', ' ').capitalize
    end

    def build_data
      build_html
    end

    def add_navigation_section(text)
      self.navigation_section_count += 1
      add_navigation_section_html(text)
    end

    def sample_by_name(sample_name)
      path = Rails.root.join('vendor', 'frontify', 'components', name, 'doc', sample_name, 'sample.html')
      File.exists?(path) ? File.open(path, 'r').read.to_s : ''
    end

    private

    def add_navigation_section_html(text)
      klass = self.navigation_section_count == 1 ? 'is-active' : ''
      self.navigation_section_html += "<a href='#section-#{ self.navigation_section_count }' class='alg-page-section #{ klass }'>#{ text }</a>"
    end

    def build_html
      base_path    = Rails.root.join('vendor', 'frontify', 'components', name, 'doc', '*')
      readme_path  = Rails.root.join('vendor', 'frontify', 'components', name, 'doc', 'README.md')
      markdown     = Redcarpet::Markdown.new(Frontify::Component::CustomRender, { component: self, tables: true, fenced_code_blocks: true })
      samples_path = Dir[base_path.to_s] - [readme_path.to_s]

      markdown_to_html(readme_path, markdown)
      samples_path.sort.each do |path|
        _path = "#{ path }/README.md"
        sample = path.split('/')[-1]
        markdown_to_html(_path, markdown)
        page_to_iframe(sample)
      end
    end

    def page_to_iframe(sample)
      path = Rails.root.join('vendor', 'frontify', 'components', name, 'doc', sample, 'sample.html')

      if File.exists?(path)
        content = [
          "<div class='alg-viewport js-viewport'>",
            "<nav class='alg-viewport-size'>",
              "<select data-view-port-resize>",
                "<option value="">Selecione uma opção</option>",
                "<option value='laptop-l' class='alg-viewport-size-option'>Laptop L - 1440px</option>",
                "<option value='laptop' class='alg-viewport-size-option'>Laptop - 1024px</option>",
                "<option value='tablet' class='alg-viewport-size-option'>Tablet - 768px</option>",
                "<option value='mobile-l' class='alg-viewport-size-option'>Mobile L - 425px</option>",
                "<option value='mobile-m' class='alg-viewport-size-option'>Mobile M - 375px</option>",
                "<option value='mobile-s' class='alg-viewport-size-option is-active'>Mobile S - 320px</option>",
              "</select>",
            "</nav>",
            "<div class='alg-viewport-content'>",
              "<textarea class='alg-viewport-resize' disabled></textarea>",
              "<div class='alg-viewport-content-inner js-viewport-content'>",
                "<iframe src='#{ Frontify::Engine.routes.url_helpers.component_sample_path(name, sample) }'></iframe>",
              "</div>",
            "</div>",
          "</div>"
        ].join('')
        @html << content
      end
    end

    def markdown_to_html(path, markdown)
      if File.exists? path
        read_file = File.open(path, 'r').read.to_s
        content   = "<section class='alg-container'>" + markdown.render(read_file) + '</section>'
        @html << content
      end
    end
  end
end

