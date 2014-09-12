# ViewSourceMap
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

then see the source of your page:

![](http://dl.dropbox.com/u/5978869/image/20121204_171625.png)

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
