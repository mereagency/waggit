# Helper class for manipulating file system
#
class Files

  # If we have scss files that we edit, their compiled css equivalents need
  # to be deleted in order for wagon to recompile the scss
  #
  def self.clean_scss()
    Dir.glob('**/*.scss').each do|f|
      puts "Found scss file: #{f}."
      f.sub(".scss", '')
      puts "Searching for css file: #{f}."
      if File.file?(f)
        puts "CSS file found"
        File.delete(f)
        puts "CSS file deleted"
      else
        puts "CSS not file found"
      end
    end
  end

end
