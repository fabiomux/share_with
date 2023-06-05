# ShareWith

This is a Ruby gem thought to render the sharing links for the most popular networks.

*ShareWith* also introduces a syntax, built upon a YAML file, to declare parameters and templates, and
elements to self-describe the service itself.

This YAML file will be used to generate the object that renders the templates in plain HTML text.

[![Ruby](https://github.com/fabiomux/share_with/actions/workflows/main.yml/badge.svg)][wf_main]
[![Gem Version](https://badge.fury.io/rb/share_with.svg)][gem_version]

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add share_with

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install share_with

## Usage

As first step must *require* the gem:
```ruby
require "share_with"
```

Then we can instantiate the *Collection* class and the list of services to load: 
```ruby
@collection = ShareWith::Collection.new(services: ["twitter", "facebook"])
```

Once filled the *params* required to render the template:
```ruby
@collection.set_value_to_all("url", "https://freeaptitude.altervista.org/projects/share-with.html")
```

Finally we get the HTML code as a text string:
```ruby
@collection.render_all("icon")
```

## More Help

- the [project page on the Freeaptitude blog][project_page];
- the [ShareWith Github wiki][share_with_wiki].

[project_page]: https://freeaptitude.altervista.org/projects/share-with.html "Project page on the Freeaptitude blog"
[share_with_wiki]: https://github.com/fabiomux/share_with/wiki "ShareWith wiki page on GitHub"
[wf_main]: https://github.com/fabiomux/share_with/actions/workflows/main.yml
[gem_version]: https://badge.fury.io/rb/share_with
