Gem::Specification.new do |s|
  s.name  = 'waggit'
  s.version   = '0.0.001'
  s.date  ='2014-07-30'
  s.summary = 'Wagon + Git = :)'
  s.description  = "A way of integrating LocomotiveCMS/Wagon with git. This is under development and not ready for active use."
  s.authors = ["Mere Agency"]
  s.email = "support@mereagency"
  s.files = ["lib/waggit.rb", "lib/git.rb", "lib/wagon.rb", "lib/command.rb", "lib/files.rb"]
  s.homepage = "http://rubygems.org/gems/waggit"
  s.platform = Gem::Platform::RUBY
  s.executables << 'waggit'
  s.license       = 'MIT'
end
