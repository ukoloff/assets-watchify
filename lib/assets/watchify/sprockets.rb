module Assets::Watchify::Helper
  def javascript_include_tag(*sources)
    sources.map {|s| Assets::Watchify.jstag s }.join("\n").html_safe
  end
end
