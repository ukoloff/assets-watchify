require 'source_map'
require 'listen'
require 'wdm' if Gem.win_platform?

module Assets::Watchify
  Helper=Sprockets::Helpers::RailsHelper rescue Sprockets::Rails::Helper

  require_relative 'sprockets'

  def self.clean
    Dir.glob Root.join '**', '*' do |f|
      File.delete f rescue nil
    end
  end

  def self.mkdir
    FileUtils.mkpath Root
  end

  def self.rmdir
    FileUtils.remove_entry Root
  end

  def self.ms seconds
    seconds.round 3
  end

  def self.jstag name
    return unless String===name
    t1 = Time.now
    name+='.js' if File.extname(name).empty?
    begin
      z = Rails.application.assets[name]
    rescue=> e
      return "<div class='alert alert-error'><pre>#{e.message}</pre></div>"
    end

    t2 = Time.now

    unless File.exist? js = Root.join(z.digest_path)
      File.delete @bundles[name], "#{@bundles[name]}.map" rescue nil if @bundles[name]
      @bundles[name] = js
      FileUtils.mkpath js.dirname
      jsf = File.open js, 'w+'
      map = SourceMap.new file: js.basename, source_root: '/assets', generated_output: jsf
      z.to_a.each {|d| map.add_generated d.source, source: d.logical_path+'?body=1'}
      map.save "#{js}.map"
      jsf.puts
      jsf.puts "//# sourceMappingURL=#{File::basename js}.map"
      jsf.close
      t3 = Time.now
      puts "#{self} built '#{name}' (#{ms t2-t1}+#{ms t3-t2}=#{ms t3-t1})..."
    end
    "<script src='/assets/#{Folder}/#{z.digest_path}'></script><!-- #{z.length}/#{z.to_a.length} -->"
  end

  def self.ping
    @bundles.keys.each{|name| jstag name}
  end

  def self.path? f
    Pathname.new(f).realpath.ascend do |z|
      return false if Pathname.glob(z+'*.gemspec').any?
      return true if z.join('Gemfile').file?
    end
    true
  end

  def self.pathz
    @paths||=Rails.application.config.assets.paths#.select{|f| path? f}
  end

  def self.start!
    clean
    Rails.application.config.assets.debug = false # Let CSS to glue either

    paths=pathz

    Thread.new do
      listener = Listen.to paths do |m,a,r|
        m.each {|f| puts "~ #{f}"}
        a.each {|f| puts "+ #{f}"}
        r.each {|f| puts "- #{f}"}
        ping
      end
      listener.start
      puts "#{self} listening to changes in #{paths.count} folders..."
      at_exit do
        puts "#{self } stop listening to folders..."
        listener.stop
        clean
      end
      sleep 1
      ping
    end
  end

  start!
end
