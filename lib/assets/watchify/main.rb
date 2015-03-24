require 'source_map'
require 'listen'
require 'wdm' if Gem.win_platform?

module Assets::Watchify
  Helper=Sprockets::Helpers::RailsHelper rescue Sprockets::Rails::Helper

  require_relative 'sprockets'

  def self.jstag s
    "<!-- JS: #{s} -->"
  end
end
