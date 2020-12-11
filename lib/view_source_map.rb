require 'view_source_map/railtie'

if Rails.gem_version >= Gem::Version.new('6')
  require 'view_source_map_rails_6_0'
else
  require 'view_source_map_rails_4_and_5'
end

module ViewSourceMap
  def self.detach
    return unless @attached
    @attached = false
    ActionView::PartialRenderer.class_eval do
      undef_method :render_with_path_comment
      alias_method :render, :render_without_path_comment
    end

    ActionView::TemplateRenderer.class_eval do
      undef_method :render_template_with_path_comment
      alias_method :render_template, :render_template_without_path_comment
    end
  end

  def self.force_disabled?(options)
    return false if options.nil?
    return true  if options[:view_source_map] == false
    return false if options[:locals].nil?
    options[:locals][:view_source_map] == false
  end
end
