module ViewSourceMap
  class Railtie < Rails::Railtie
    initializer "render_with_path_comment.initialize" do
      if !ENV["DISABLE_VIEW_SOURCE_MAP"] && Rails.env.development?
        ViewSourceMap.attach
      end
    end
  end

  def self.attach
    return if defined?(@attached) && @attached
    @attached = true
    ActionView::PartialRenderer.class_eval do
      def render_with_path_comment(context, options, block)
        content = render_without_path_comment(context, options, block)
        return content if ViewSourceMap.force_disabled?(options)

        if @lookup_context.formats.first == :html
          name = ViewSourceMap.find_name(content, options)
          return content unless name
          ViewSourceMap.update_content_with_comment!(content, name)
        else
          content
        end
      end
      alias_method :render_without_path_comment, :render
      alias_method :render, :render_with_path_comment
    end


    ActionView::TemplateRenderer.class_eval do
      def render_template_with_path_comment(view, template, layout_name, locals)
        render_with_layout(view, template, layout_name, locals) do |layout|
          instrument(:template, identifier: template.identifier, layout: layout.try(:virtual_path)) do
            content = template.render(view, locals) { |*name| view._layout_for(*name) }
            return content if ViewSourceMap.force_disabled?(locals)

            path = Pathname.new(template.identifier)

            if @lookup_context.formats.first == :html && path.file?
              name = path.relative_path_from(Rails.root)
              "<!-- BEGIN #{name} -->\n#{content}<!-- END #{name} -->".html_safe
            else
              content
            end
          end
        end
      end
      alias_method :render_template_without_path_comment, :render_template
      alias_method :render_template, :render_template_with_path_comment
    end
  end

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

  def self.find_name(content, options)
    return "#{options[:layout]}(layout)" if options[:layout]

    template = if content.is_a?(ActionView::AbstractRenderer::RenderedCollection)
                 content.rendered_templates.first.template
               elsif content.is_a?(ActionView::AbstractRenderer::RenderedTemplate)
                 content.template
               end

    return nil unless template.respond_to?(:identifier)
    path = Pathname.new(template.identifier)
    path.relative_path_from(Rails.root)
  end

  def self.update_content_with_comment!(content, name)
    if content.is_a?(ActionView::AbstractRenderer::RenderedCollection)
      content.instance_eval do
        @rendered_templates.first.instance_eval { @body = "<!-- BEGIN #{name} -->\n#{@body}".html_safe }
        @rendered_templates.last.instance_eval { @body = "#{@body}<!-- END #{name} -->".html_safe }
      end
    elsif content.is_a?(ActionView::AbstractRenderer::RenderedTemplate)
      content.instance_eval { @body = "<!-- BEGIN #{name} -->\n#{@body}<!-- END #{name} -->".html_safe }
    end
    content
  end

  def self.force_disabled?(options)
    return false if options.nil?
    return true  if options[:view_source_map] == false
    return false if options[:locals].nil?
    options[:locals][:view_source_map] == false
  end
end
