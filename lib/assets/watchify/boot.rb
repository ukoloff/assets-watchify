require_relative "version"

module Assets::Watchify
  Folder='w6y'

  Prefix=Rails.application.config.assets.prefix
  Path=Prefix+'/'+Folder
  Root=Rails.root.join "public"+Path

  def self.use?
    defined?(Rails::Server) &&
    'development'==Rails.env &&
    Dir.exist?(Root)
  end

  require_relative "main" if use?
end
