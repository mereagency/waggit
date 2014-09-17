# Helper class for manipulating file system
#
module Files

  # If we have scss files that we edit, their compiled css equivalents need
  # to be deleted in order for wagon to recompile the scss
  #
  def self.clean_css()
    Dir.glob('**/*.css').each do|css_file|
      puts "Found css file: #{css_file}"
      scss_file = css_file + ".scss"
      puts "Searching for scss file: #{scss_file }"
      if File.file?(scss_file )
        puts "SCSS file found"
        File.delete(css_file)
        if css_file.include? '/'
          "/" + css_file
        end
        if File.file?(css_file)
          puts "ERROR: CSS file not deleted!"
        else
          puts "CSS file deleted"
        end
      else
        puts "SCSS not file found"
      end
    end
  end

end
