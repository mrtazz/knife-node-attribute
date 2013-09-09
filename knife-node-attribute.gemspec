$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'knife-node-attribute'
  gem.version       = '0.2.0'
  gem.authors       = ["Daniel Schauenberg"]
  gem.email         = 'd@unwiredcouch.com'
  gem.homepage      = 'https://github.com/mrtazz/knife-node-attribute'
  gem.summary       = "knife plugin to show or delete node attributes"
  gem.description   = "knife plugin to show or delete node attributes"

  gem.files         = `git ls-files`.split($\)
  gem.name          = "knife-node-attribute"
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'chef', '>= 0.10.4'
end
