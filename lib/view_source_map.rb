module ViewSourceMap
  class Railtie < Rails::Railtie
    initializer "render_with_path_comment.initialize" do
      if !ENV["DISABLE_VIEW_SOURCE_MAP"] && Rails.env.development?
        ViewSourceMap.attach
      end
    end
  end

  def self.attach
    ActionView::PartialRenderer.class_eval do
      def render_with_path_comment(context, options, block)
        content = render_without_path_comment(context, options, block)

        if @lookup_context.rendered_format == :html
          if options[:layout]
            name = "#{options[:layout]}(layout)"
          else
            path = Pathname.new(@template.identifier)
            name = path.relative_path_from(Rails.root)
          end
          "<!-- BEGIN #{name} -->#{content}<!-- END #{name} -->".html_safe
        else
          content
        end
      end
      alias_method_chain :render, :path_comment
    end
  end

  def self.detach
    ActionView::PartialRenderer.class_eval do
      undef_method :render_with_path_comment
      alias_method :render, :render_without_path_comment
    end
  end
end
