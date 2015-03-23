namespace :apps do
  desc 'Install rails for testing'
  task :init do
    require 'fileutils'
    %w(3 4).each do |ver|
      FileUtils.mkdir_p app="test/v#{ver}"
      next if File.exists? gemfile="#{app}/Gemfile"
      system *%w(bundle init), chdir: app
      File.open gemfile, 'a' do |f|
        f.puts "gem 'rails', '~>#{ver}'"
      end
      system *%w(bundle install), chdir: app
      system *%w(bundle exec rails new . --force --skip-bundle), chdir: app
      gf=File.read(gemfile).each_line.reject{|s|/tzinfo-data/.match s}+
        <<-EOG.each_line.map(&:lstrip)
          gem 'assets-watchify', path: '../..'
          gem 'therubyracer' unless Gem.win_platform?
          gem 'tzinfo-data'      if #{'3'==ver ? 'false' : 'Gem.win_platform?'}
        EOG
      File.write gemfile, gf*""
      system *%w(bundle install), chdir: app
    end
  end

  task :clear do
    FileUtils.remove_dir 'test'
  end
end
