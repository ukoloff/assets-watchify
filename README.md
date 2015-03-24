# Assets::Watchify

[![Gem Version](https://badge.fury.io/rb/assets-watchify.svg)](http://badge.fury.io/rb/assets-watchify)

Fast serving Rails assets in development.

Useful for Rails applications with hundreds of JavaScript files
(eg Backbone Marionette at client side).

This Gem doesn't use Watchify, Browserify or Node.js.
Rails Assets Pipeline is smart enough to do all the job.
We just set a couple of hooks.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'assets-watchify', group: :development
```
And then execute:

```sh
$ bundle
```
Or install it yourself as:

```sh
$ gem install assets-watchify
```
## Usage

Create folder `public/assets/w6y` and start rails server.

## Operation

The Gem:

  * Instructs Rails to concatenate CSS files together
  * Installs hook on generating JavaScript tag
  * Combines all JavaScript assets into single file
  * Generates SourceMap for concatenated JavaScript
  * Listens to changes in asset folders and rebuilds JavaScript files

For Rails v3 it's enough.

Rails v4 is slooow serving large files (and combined JavaScript is large!).
Use nginx as reverse proxy:

```
server {
  listen 80;

  root  /my/Rails/app/public;

  location @Rails {
    proxy_pass http://127.0.0.1:3000;
  }

  location / {
    try_files $uri @Rails;
  }
}

```
## Precompilation

It's useful sometimes to compile large JavaScript on Rails server start.
Request this with `preload` method:

```ruby
# config/initializers/watchify.rb
Assets::Watchify.preload 'application.js', 'my/other.js' rescue nil
```

`preload` without arguments is `preload 'application.js'`.

## See also

  * [OpenSSL::Win::Root](https://github.com/ukoloff/openssl-win-root)
  * [ExecJS::Xtrn](https://github.com/ukoloff/execjs-xtrn)

## Credits

  * [Ruby](https://www.ruby-lang.org/)
  * [Ruby on Rails](http://rubyonrails.org/)
  * [nginx](http://nginx.org/)
  * Gem [source_map](https://github.com/ConradIrwin/ruby-source_map)
  * [Listen](https://github.com/guard/listen)
  * [Backbone Marionette](http://marionettejs.com/)
