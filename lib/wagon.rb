require_relative '../lib/command.rb'
require 'yaml'
require 'pathname'
require 'json'
require 'httparty'

module Waggit
  # Wrapper module for `wagon` commands. This contains all wagon methods and 
  # classes. 
  #
  module Wagon
    #TODO: make this an option to the user on the command line 
    # params and as a persistent setting.
    @@environment_name = "production" 

    def self.environment_name
      @@environment_name
    end

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
      Command.run("bundle exec wagon pull #{@@environment_name}#{self.process_options(options)}")
    end

    def self.push(options)
      Command.run("bundle exec wagon push #{@@environment_name}#{self.process_options(options)}")
    end

    def self.push_page(page)
      # Pushes the state of the page up to the server. This requires that the
      # page have it's id set to uniquely identify it.
      fail WagonException("Tried to push page '#{page.fullpath}', but no id was set") unless page.id

      url = "#{environment['host']}/locomotive/api/pages/#{page.id}/.json?auth_token=#{token}"

      response = HTTParty.put(url, data)

      #curl -X PUT -d 'site[name]=TEST' 'http://<your site>/locomotive/api/current_site.json?auth_token=K9zm8niKTxuM4ZMNK7Ct'

      #curl -X POST -d 'page[title]=Hello world&page[slug]=hello-world&page[parent_fullpath]=index&page[raw_template]=Built with the API&page[listed]=true&page[published]=true' 'http://<your site>/locomotive/api/current_site.json?auth_token=K9zm8niKTxuM4ZMNK7Ct'
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
    def self.get_wagon_path
      dir = nil
      if is_wagon_dir? Dir.pwd
        dir = Dir.pwd
      else
        Pathname.new(Dir.pwd).ascend do |parent|
          if is_wagon_dir? parent
            dir = parent.to_s
            break
          end
        end
      end
      return dir
    end

    def self.get_site_file
      path = get_wagon_path
      File.join(path, 'config', 'site.yml') if path
    end

    def self.get_deploy_file
      path = get_wagon_path
      File.join(path, 'config', 'deploy.yml') if path
    end

    def self.get_pages_dir
      path = get_wagon_path
      File.join(path, 'app', 'views', 'pages') if path
    end

    def self.get_index_page_file
      path = get_pages_dir
      File.join(path, 'index.liquid') if path
    end

    def self.get_404_page_file
      path = get_pages_dir
      File.join(path, '404.liquid') if path
    end
  end
end
