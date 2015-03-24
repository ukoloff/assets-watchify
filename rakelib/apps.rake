namespace :apps do
  desc 'Install rails for testing'
  task :init do
    require 'fileutils'
    FileUtils.mkdir_p "test"
    html=File.open "test/index.html", 'a'
    %w(3 4).each do |ver|
      html.puts "<li><a href='http://localhost:300#{ver}'>v#{ver}</a>"
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
          gem 'byebug', group: :development
          gem 'assets-watchify', path: '../..'
          gem 'therubyracer' unless Gem.win_platform?
          gem 'tzinfo-data'      if #{'3'==ver ? 'false' : 'Gem.win_platform?'}
        EOG
      File.write gemfile, gf*""
      system *%w(bundle install), chdir: app
      system *%w(bundle exec rails g controller welcome index), chdir: app
      File.unlink "#{app}/public/index.html" rescue nil
      FileUtils.mkdir_p "#{app}/public/assets/w6y"
      File.open "#{app}/config/routes.rb", 'w' do |f|
        f.puts <<-EOF
Rails.application.routes.draw do
  root to: "welcome#index"
end
        EOF
      end
    end
  end

  task :clear do
    FileUtils.remove_dir 'test'
  end
end
