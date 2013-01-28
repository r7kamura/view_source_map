require "spec_helper"

describe ExamplesController do
  describe "#index" do
    context "when render as HTML" do
      subject do
        get :index
      end

      context "when RenderWithPathComment is not attached" do
        it "does not show partial view's relative path as HTML comment" do
          should be_success
          response.body.should_not include("<!-- BEGIN app/views/examples/_example.html.erb -->")
          response.body.should_not include("<!-- END app/views/examples/_example.html.erb -->")
        end
      end

      context "when RenderWithPathComment is attached" do
        before do
          ViewSourceMap.attach
        end

        it "shows partial view's relative path as HTML comment" do
          should be_success
          response.body.should include("<!-- BEGIN app/views/examples/_example.html.erb -->")
          response.body.should include("<!-- END app/views/examples/_example.html.erb -->")
        end
      end

      context "when ViewSourceMap is detached" do
        before do
          ViewSourceMap.detach
        end

        it "does not show partial view's relative path as HTML comment" do
          should be_success
          response.body.should_not include("<!-- BEGIN app/views/examples/_example.html.erb -->")
          response.body.should_not include("<!-- END app/views/examples/_example.html.erb -->")
        end
      end
    end

    context "when render as TEXT" do
      subject do
        get "index", :format => "text"
      end

      context "when RenderWithPathComment is attached" do
        before do
          ViewSourceMap.attach
        end

        it "does not show partial view's relative path as HTML comment" do
          should be_success
          response.body.should_not include("<!-- BEGIN app/views/examples/_text.text.erb -->")
          response.body.should_not include("<!-- END app/views/examples/_text.text.erb -->")
        end
      end
    end
  end
end
