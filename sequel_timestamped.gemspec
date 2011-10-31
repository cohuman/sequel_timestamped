require 'lib/sequel_timestamped'

Gem::Specification.new do |s|
  s.name                = "sequel_timestamped"
  s.summary             = "Automatically set :created_at and :updated_at in Sequel"
  s.description         = "If your model is :timestamped, it will automatically set the :created_at and :updated_at columns if they exist"
  s.author              = ["bricooke", 'cohuman']
  s.email               = ["brian@madebyrocket.com", 'dev@cohuman.com']
  s.homepage            = "http://github.com/cohuman/sequel_timestamped"
  s.require_path        = "lib"
  s.version             =  Sequel::Plugins::Timestamped::VERSION
  s.files               =  File.read("Manifest").strip.split("\n")
  s.add_dependency 'sequel'
end


