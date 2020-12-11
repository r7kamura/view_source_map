module ViewSourceMap
  def self.attach
    return if defined?(@attached) && @attached
    @attached = true

    ActionView::PartialRenderer.class_eval do
      def render_with_path_comment(partial, context, block)
        content = render_without_path_comment(partial, context, block)
        return content if ViewSourceMap.force_disabled?(@options)

        if @lookup_context.formats.first == :html
          case content
          when ActionView::AbstractRenderer::RenderedCollection
            content.rendered_templates.each do |rendered_template|
              ViewSourceMap.wrap_rendered_template(rendered_template, @options)
            end
          when ActionView::AbstractRenderer::RenderedTemplate
            ViewSourceMap.wrap_rendered_template(content, @options)
          end
        end
        content
      end
      alias_method :render_without_path_comment, :render
      alias_method :render, :render_with_path_comment
    end

    ActionView::TemplateRenderer.class_eval do
      def render_template_with_path_comment(view, template, layout_name, locals)
        render_with_layout(view, template, layout_name, locals) do |layout|
          ActiveSupport::Notifications.instrument(
            'render_template.action_view',
            identifier: template.identifier,
            layout: layout.try(:virtual_path),
          ) do
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

  # @private
  # @param [ActionView::AbstractRenderer::RenderedTemplate] rendered_template
  # @param [Hash] options Options passed to #render method.
  def self.wrap_rendered_template(rendered_template, options)
    name = begin
      if options[:layout]
        "#{options[:layout]}(layout)"
      elsif rendered_template.template.respond_to?(:identifier)
        Pathname.new(rendered_template.template.identifier).relative_path_from(Rails.root)
      end
    end

    if name
      rendered_template.instance_variable_set(
        :@body,
        "<!-- BEGIN #{name} -->\n#{rendered_template.body}<!-- END #{name} -->".html_safe
      )
    end
  end
end
