# Assets::Watchify

[![Gem Version](https://badge.fury.io/rb/assets-watchify.svg)](http://badge.fury.io/rb/assets-watchify)

Fast serving Rails assets in development.

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

## See also

  * [OpenSSL::Win::Root](https://github.com/ukoloff/openssl-win-root)
  * [ExecJS::Xtrn](https://github.com/ukoloff/execjs-xtrn)

## Credits

  * [Ruby](https://www.ruby-lang.org/)
  * [Ruby on Rails](http://rubyonrails.org/)
  * [nginx](http://nginx.org/)
  * Gem [source_map](https://github.com/ConradIrwin/ruby-source_map)
  * [Listen](https://github.com/guard/listen)
