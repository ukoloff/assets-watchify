require_relative "watchify/version"

if Gem.win_platform?
  require 'execjs/xtrn'
  require 'openssl/win/root'
end

class Rails::Application
  initializer :assets_watchify do
    require_relative 'watchify/boot'
  end
end

module Assets::Watchify
  @bundles={}

  def self.preload *args
    args=['application.js'] if args.empty?
    args.flatten.compact.each{|js| @bundles[js]=nil}
  end
end
