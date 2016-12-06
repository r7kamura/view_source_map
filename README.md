# ViewSourceMap

[![Gem](https://img.shields.io/gem/v/view_source_map.svg)](https://rubygems.org/gems/view_source_map)
[![Build Status](https://travis-ci.org/r7kamura/view_source_map.svg?branch=master)](https://travis-ci.org/r7kamura/view_source_map)

This is a Rails plugin to insert the path name of a rendered partial view as HTML comment in development environment.

## Usage

In your Gemfile

```ruby
group :development do
  gem "view_source_map"
end
```

and launch your rails server in development environment:

```
$ rails s
```

## Tips

Sometimes this adds too much noise to the html when you're developing.
There is a simple way to turn it off.

```
$ DISABLE_VIEW_SOURCE_MAP=1 rails s
```

or

```
<%= render "example_disabled", view_source_map: false %>
<%= render partial: "example_disabled_partial", view_source_map: false %>
```
