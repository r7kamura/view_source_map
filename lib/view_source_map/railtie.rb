module ViewSourceMap
  class Railtie < Rails::Railtie
    initializer "render_with_path_comment.initialize" do
      if !ENV["DISABLE_VIEW_SOURCE_MAP"] && Rails.env.development?
        ViewSourceMap.attach
      end
    end
  end
end
