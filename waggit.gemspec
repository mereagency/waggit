Gem::Specification.new do |s|
  s.name  = 'waggit'
  s.version   = '0.0.011'
  s.date  ='2014-09-17'
  s.summary = 'Wagon + Git = :)'
  s.description  = "A way of integrating LocomotiveCMS/Wagon with git. This is under development and not ready for active use."
  s.authors = ["Mere Agency"]
  s.email = "support@mereagency.com"
  s.files = ["lib/waggit.rb", "lib/git.rb", "lib/wagon.rb", "lib/command.rb", "lib/files.rb"]
  s.homepage = "https://github.com/mereagency/waggit"
  s.platform = Gem::Platform::RUBY
  s.executables << 'waggit'
  s.license       = 'MIT'
end
