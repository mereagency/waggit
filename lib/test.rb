require './exceptions.rb'

begin 
  raise Waggit::GitCheckoutException
rescue Waggit::WaggitException => e
  puts '1'
  puts e.message
  puts '2'
end