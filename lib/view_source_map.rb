module ViewSourceMap
  class Railtie < Rails::Railtie
    initializer "render_with_path_comment.initialize" do
      ViewSourceMap.attach if Rails.env.development?
    end
  end

  def self.attach
    ActionView::PartialRenderer.class_eval do
      def render_with_path_comment(context, options, block)
        content = render_without_path_comment(context, options, block)
        if options[:layout]
          name = "#{options[:layout]}(layout)"
        else
          path = Pathname.new(@template.identifier)
          name = path.relative_path_from(Rails.root)
        end
        "<!-- BEGIN #{name} -->#{content}<!-- END #{name} -->".html_safe
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
