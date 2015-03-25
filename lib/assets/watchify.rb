require_relative "watchify/version"

if Gem.win_platform?
  require 'execjs/xtrn'
  require 'openssl/win/root'
end

class Rails::Application
  initializer :assets_watchify do
    Assets::Watchify.boot!
  end
end

module Assets::Watchify
  Folder='w6y'

  @bundles={}

  def self.preload *args
    args=['application.js'] if args.empty?
    args.flatten.compact.each{|js| @bundles[js]=nil}
  end

  def self.use?
    defined?(Rails::Server) &&
    'development'==Rails.env &&
    @root.directory?
  end

  def self.boot!
    @prefix=Rails.application.config.assets.prefix
    @path=@prefix+'/'+Folder
    @root=Rails.root.join "public"+@path
    return unless use?
    require_relative "watchify/main"
    start!
  end

  def self.mkdir
    FileUtils.mkpath @root
  end
end
