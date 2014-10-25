require 'command'

module Waggit::Wagon

  # Converts the provided options into the appropriate
  # string to append to the wagon command. 
  # Supported options:
  #   "-p" or "-pages": pages
  #   "-a" or "-theme_assets": theme_assets
  #   "-t" or "-translations": translations
  #   "-e" or "-content_entries": content_entries
  #   "-y" or "-content_types": content_types
  #   "-n" or "-snippets": snippets
  #   "-s" or "-site": site
  #   
  def self.process_options(options)
    resource_opts = []
    for option in options
      case option
      when "-p", "-pages"
        unless resource_opts.include? "pages"
          resource_opts.push("pages")
        end
      when "-a", "-theme_assets"
        unless resource_opts.include? "theme_assets"
          resource_opts.push("theme_assets")
        end
      when "-t", "-translations"
        unless resource_opts.include? "translations"
          resource_opts.push("translations")
        end
      when "-e", "-content_entries"
        unless resource_opts.include? "content_entries"
          resource_opts.push("content_entries")
        end
      when "-y", "-content_types"
        unless resource_opts.include? "content_types"
          resource_opts.push("content_types")
        end
      when "-n", "-snippets"
        unless resource_opts.include? "snippets"
          resource_opts.push("snippets")
        end
      when "-s", "-site"
        unless resource_opts.include? "site"
          resource_opts.push("site")
        end
      end
    end
    unless resource_opts.empty?
      return " -r #{resource_opts.join(' ')}"
    else
      return ''
    end
  end

  def self.pull(options)
    Command.run("bundle exec wagon pull production#{self.process_options(options)}")
  end

  def self.push(options)
    Command.run("bundle exec wagon push production#{self.process_options(options)}")
  end


  # FROM : https://github.com/locomotivecms/wagon/blob/master/lib/locomotive/wagon/cli.rb#L8-L31
  # This method is heavily tweaked and may require more modifications to be acurate.
  # Check if the path given in option ('.' by default) points to a LocomotiveCMS
  # site. It is also possible to pass a path other than the one from the options.
  #
  # @param [ String ] path The optional path of the site instead of options['path']
  #
  # @return [ String ] The fullpath to the LocomotiveCMS site or nil if it is not a valid site.
  #
  def self.is_wagon_dir?(path = '.')
    path = path == '.' ? Dir.pwd : File.expand_path(path)
    return  File.exists?(File.join(path, 'config', 'site.yml')) 
  end

  # Determines if there is a wagon path in the immediate directory or the directory above it. 
  # If so, the path will be returned, otherwise nill. This does not search sub directories.
  def self.get_wagon_path()
    dir = nil
    if is_wagon_dir? Dir.pwd
      dir = Dir.pwd
    else
      require 'pathname'
      Pathname.new(Dir.pwd).ascend do |parent|
        if is_wagon_dir? parent
          dir = parent.to_s
          break
        end
      end
    end
    return dir
  end

end
