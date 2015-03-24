require_relative "version"

module Assets::Watchify
  Folder='w6y'

  Root=Rails.root.join "public/assets", Folder

  def self.use?
    defined?(Rails::Server) &&
    'development'==Rails.env &&
    Dir.exist?(Root)
  end

  require_relative "main" if use?
end
