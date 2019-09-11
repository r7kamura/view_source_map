require "rails_helper"

describe ExamplesController do
  describe "#index" do
    context "when render as HTML" do
      subject do
        get :index
      end

      context "when RenderWithPathComment is not attached" do
        before do
          ViewSourceMap.detach
        end

        it "does not show partial view's relative path as HTML comment" do
          should be_successful
          response.body.should_not include("<!-- BEGIN app/views/examples/_example.html.erb -->")
          response.body.should_not include("<!-- END app/views/examples/_example.html.erb -->")
          response.body.should_not include("<!-- BEGIN app/views/examples/index.html.erb -->")
          response.body.should_not include("<!-- END app/views/examples/index.html.erb -->")
        end
      end

      context "when RenderWithPathComment is attached" do
        before do
          ViewSourceMap.attach
        end

        it "shows partial view's relative path as HTML comment" do
          should be_successful
          response.body.should include("<!-- BEGIN app/views/examples/_example.html.erb -->")
          response.body.should include("<!-- END app/views/examples/_example.html.erb -->")
          response.body.should include("<!-- BEGIN app/views/examples/index.html.erb -->")
          response.body.should include("<!-- END app/views/examples/index.html.erb -->")
        end

        it "does not show partial view's relative path as HTML comment when disabled" do
          response.body.should_not include("<!-- BEGIN app/views/examples/_example_disabled.html.erb -->")
          response.body.should_not include("<!-- BEGIN app/views/examples/_example_disabled_partial.html.erb -->")
        end
      end

      context "when ViewSourceMap is detached" do
        before do
          ViewSourceMap.detach
        end

        it "does not show partial view's relative path as HTML comment" do
          should be_successful
          response.body.should_not include("<!-- BEGIN app/views/examples/_example.html.erb -->")
          response.body.should_not include("<!-- END app/views/examples/_example.html.erb -->")
          response.body.should_not include("<!-- BEGIN app/views/examples/index.html.erb -->")
          response.body.should_not include("<!-- END app/views/examples/index.html.erb -->")
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
          should be_successful
          response.body.should_not include("<!-- BEGIN app/views/examples/_example.text.erb -->")
          response.body.should_not include("<!-- END app/views/examples/_example.text.erb -->")
          response.body.should_not include("<!-- BEGIN app/views/examples/index.text.erb -->")
          response.body.should_not include("<!-- END app/views/examples/index.text.erb -->")
        end
      end
    end
  end

  describe "#render_to_string" do
    before do
      ViewSourceMap.attach
    end

    let(:template)   { '_example' }
    let(:locals)     { {} }
    subject do
      described_class.new.render_to_string(template, locals: locals)
    end

    context 'with no option' do
      it "shows partial view's relative path as HTML comment" do
        subject.should include("<!-- BEGIN app/views/examples/_example.html.erb -->")
      end
    end

    context 'with disable option' do
      let(:locals) { { view_source_map: false } }
      it "does not show partial view's relative path as HTML comment" do
        subject.should_not include("<!-- BEGIN app/views/examples/_example.html.erb -->")
      end
    end
  end
end
