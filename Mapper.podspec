Pod::Spec.new do |s|
  s.name = "Mapper"
  s.version = "0.4.0"
  s.summary = "Object mapping made easy"
  s.description = <<-DESC
                   * Object mapping made easy
                   DESC
  s.homepage = "https://github.com/zenangst/Mapper"
  s.license = {
    :type => 'MIT',
    :file => 'LICENSE.md'
  }
  s.author = { "Christoffer Winterkvist" => "christoffer@winterkvist.com" }
  s.social_media_url = "https://twitter.com/zenangst"
  s.platform = :ios, '6.0'
  s.source = {
    :git => 'https://github.com/zenangst/Mapper.git',
    :tag => s.version.to_s
  }
  s.source_files = 'Source/*.*'
  s.frameworks = 'Foundation'
  s.requires_arc = true
end
