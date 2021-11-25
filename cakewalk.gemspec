Gem::Specification.new do |s|
  s.name = 'cakewalk'
  s.version = '3.0.0'
  s.summary = 'An IRC Bot Building Framework'
  s.description = 'A simple, friendly DSL for creating IRC bots'
  s.authors = ['Petru Madar']
  s.email = ['petru@mdr.sh']
  s.homepage = 'http://cakewalk.mdr.sh'
  s.required_ruby_version = '>= 3.0.1'
  s.files = Dir['LICENSE', 'README.md', '.yardopts', '{docs,lib,examples}/**/*']
  s.has_rdoc = "yard"
  s.license = "MIT"
end
