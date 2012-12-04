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
