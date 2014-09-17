require 'command.rb'

module Wagon

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

end
