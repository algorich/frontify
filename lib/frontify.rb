require "frontify/engine"
require 'redcarpet'

module Frontify
  class Component
    cattr_accessor :components, :section_count, :sections_html
    attr_accessor :name, :html, :navigation_section_count, :navigation_section_html

    @@components = []

    class CustomRender < Redcarpet::Render::HTML
      def header(text, header_level)
        component = @options[:component]

        if header_level == 1
          component.increment_navigation_section
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

    def increment_navigation_section
      self.navigation_section_count += 1
      add_navigation_section
    end

    private

    def add_navigation_section
      klass = self.navigation_section_count == 1 ? 'is-active' : ''
      self.navigation_section_html += "<a href='#section-#{ self.navigation_section_count }' class='alg-page-section #{ klass }'>Seção #{ self.navigation_section_count }</a>"
    end

    def build_html
      base_path    = Rails.root.join('vendor', 'frontify', 'components', name, 'doc', '*')
      readme_path  = Rails.root.join('vendor', 'frontify', 'components', name, 'doc', 'README.md')
      markdown     = Redcarpet::Markdown.new(Frontify::Component::CustomRender, { component: self })
      samples_path = Dir[base_path.to_s] - [readme_path.to_s]

      markdown_to_html(readme_path, markdown)
      samples_path.sort.map { |path| "#{ path }/README.md" }.each do |path|
        markdown_to_html(path, markdown)
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

