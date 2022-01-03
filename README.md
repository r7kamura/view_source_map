# ViewSourceMap

[![Gem](https://img.shields.io/gem/v/view_source_map.svg)](https://rubygems.org/gems/view_source_map)
[![Build Status](https://travis-ci.org/r7kamura/view_source_map.svg?branch=master)](https://travis-ci.org/r7kamura/view_source_map)

Rails plugin to embed template path as HTML comment.

## Usage

Add this line to your application's Gemfile:

```ruby
group :development do
  gem "view_source_map"
end
```

Then you can see the rendered HTML contains some comments like this:

```html
<!-- BEGIN app/views/hello/index.html.erb -->
<p>Hello</p>
<!-- END app/views/hello/index.html.erb -->
```

### Disable

Sometimes this adds too much noise to the html when you're developing.
There is a simple way to turn it off.

```shell
DISABLE_VIEW_SOURCE_MAP=1 rails s
```

or

```erb
<%= render "example_disabled", view_source_map: false %>
<%= render partial: "example_disabled_partial", view_source_map: false %>
```
