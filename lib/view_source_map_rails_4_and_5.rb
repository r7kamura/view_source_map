module ViewSourceMap
  def self.attach
    return if defined?(@attached) && @attached
    @attached = true

    ActionView::PartialRenderer.class_eval do
      def render_with_path_comment(context, options, block)
        content = render_without_path_comment(context, options, block)
        return content if ViewSourceMap.force_disabled?(options)

        if @lookup_context.rendered_format == :html
          if options[:layout]
            name = "#{options[:layout]}(layout)"
          else
            return content unless @template.respond_to?(:identifier)
            path = Pathname.new(@template.identifier)
            name = path.relative_path_from(Rails.root)
          end
          "<!-- BEGIN #{name} -->\n#{content}<!-- END #{name} -->".html_safe
        else
          content
        end
      end
      alias_method :render_without_path_comment, :render
      alias_method :render, :render_with_path_comment
    end

    ActionView::TemplateRenderer.class_eval do
      def render_template_with_path_comment(template, layout_name = nil, locals = {})
        view, locals = @view, locals || {}

        render_with_layout(layout_name, locals) do |layout|
          instrument(:template, :identifier => template.identifier, :layout => layout.try(:virtual_path)) do
            content = template.render(view, locals) { |*name| view._layout_for(*name) }
            return content if ViewSourceMap.force_disabled?(locals)

            path = Pathname.new(template.identifier)

            if @lookup_context.rendered_format == :html && path.file?
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
end
