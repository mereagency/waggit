require_relative '../wagon.rb'

# A LocomotiveCMS page. This can be used to represent a parent or a child page
class Waggit::Wagon::Page
  attr_accessor :parent, :children, :slug, :title, :listed, :published, 
    :cache_strategy, :response_type, :position, :id, :_id, :created_at, 
    :updated_at, :response_type, :redirect, :redirect_type, :templatized,
    :templatized_from_parent, :fullpath, :localized_fullpaths, :depth, 
    :translated_in, :raw_template, :editable_elements, :filepath, :filename,
    :directory, :seo_title, :escaped_raw_template, :parent_id

  # Either with JSON from the server or YAML from local files, we get a hash
  # representing a page, and we build our pages from that.
  #
  def initialize(params)
    # Assume this is not the index unless explicitly told so
    @is_root = false
    @listed = true
    @published = true
    @cache_strategy = "none"
    @response_type = "text/html"
    @children = []

    # We assume that every key passed in is the string version of a method
    # declared using attr_accessor. Otherwise it will throw an error for bad input
    params.keys.each do |key|
      self.send "#{key}=".to_sym, params[key]
    end

    # If this is not set as the root page, double check if it should be
    #if !@is_root 
    #  if (@depth == 0 && @position == 0) || @fullpath == "404" || 
    #    (@filepath && (@filepath == Waggit::Wagon.get_index_page_file || 
    #      @filepath == Waggit::Wagon.get_404_page_file))
    #    @is_root = true
    #  end
    #end

    @root = Waggit::Wagon::Page.is_root?(self) unless @root

    if @filepath
      if !@filename
        @filename = File.basename(@filepath, ".liquid")
      end

      if !@directory
        @directory = File.dirname(@filepath)
      end

      # If there is no slug, let's create one from the filepath. If we don't
      # have a file name either then that's an error 
      if @slug.nil?
        @slug = @filename.gsub(/\s+/, "_").downcase
      end

      if !@fullpath 
        if @root
          @fullpath = @slug
        else
          #puts "constructing fullpath"
          parent_fullpath = ""
          if !@parent.root?
            parent_fullpath = "#{@parent.fullpath}/"
          end
          @fullpath = "#{parent_fullpath}#{@slug}"
        end
      end
      #puts "@slug: #{@slug}"
      #puts "@fullpath: #{@fullpath}"
      #puts "@root: #{@root}"
    end
  end

  def root?
    @root
  end

  # Returns a hash of the data used in the RESTful API for pages.
  def site_data
    {"id"=>@id,
     "created_at"=>@created_at,
     "updated_at"=>@updated_at,
     "title"=>@title,
     "slug"=>@slug, 
     "position"=>@position,
     "response_type"=>@response_type,
     "cache_strategy"=>@cache_strategy,
     "redirect"=>@redirect,
     "redirect_type"=>@redirect_type,
     "listed"=>@listed,
     "published"=>@published,
     "templatized"=>@templatized,
     "templatized_from_parent"=>@templatized_from_parent,
     "fullpath"=>@fullpath,
     "localized_fullpaths"=>@localized_fullpaths,
     "depth"=>@depth, 
     "translated_in"=>@translated_in, 
     "raw_template"=>@raw_template, 
     "escaped_raw_template"=>@escaped_raw_template,
     "editable_elements"=>@editable_elements, 
     "seo_title"=>@seo_title}
    # left out parent_id, since that shouldn't change and not all pages have one
  end

  def self.is_root?(page)
    is_root = false
    # We need to make sure no parent or parent_id was passed in:
    if !page.parent && !page.parent_id
      # We are the root if we are at the highest position in the heirarchy
      # We can't test for depth == 0 and position == 1, because any page
      # could be moved to that spot.
      if (page.depth == 0 && page.position == 0) 
          is_root = true
      # Or if we have a url fullpath that is a known root, 
      elsif page.fullpath == "404" || page.fullpath == "index"
          is_root = true
      # Or if we have a local file that is a known root file
      elsif (page.filepath && (page.filepath == Waggit::Wagon.get_index_page_file || 
            page.filepath == Waggit::Wagon.get_404_page_file))
          is_root = true
      end
    end
    return is_root
  end


  def self.write_to_file(page)
    # TODO: make this write out to the local file version of itself
  end

  def self.load_local_page(path, parent=nil)
    # We need to make sure we load the parent, if it has one. If we were passed
    # in a parent Page, use that. Othersie, do a look to see if there is a
    # parent page of this page. 
    is_root = false
    if parent.nil?
      if path == Waggit::Wagon.get_index_page_file || path == Waggit::Wagon.get_404_page_file
        # This is the index page, and so the root page of the tree structure.
        is_root = true
      else
        # This is not the root page, so there MUST be a parent page. 
        # Let's load it up and assign it as this page's parent.
        dir = File.dirname path
        parent_name = File.basename dir 
        parent_dir = File.expand_path("..", parent_name)
        parent_file = File.join(parent_dir, "#{parent_name}.liquid")
        if File.exists? parent_file
          parent = load_local_page parent_file
        else
          fail WagonException "Unable to locate parent page at '#{parent_file}'"
        end
      end
    end

    # Read the file and initialize it as a Page object
    page = nil
    File.open path do |f|
      file_data = f.read.split("---")
      page_data =  YAML.load(file_data[1])
      extra_data = {
        filepath: path, 
        raw_template: file_data[2], 
        parent: parent # If this is the root, then it will be nil
      }
      page = Waggit::Wagon::Page.new page_data.merge(extra_data)
    end
    # Load all child pages:
    child_page = nil
    # If this is the index file, then we know that all other pages are child
    # pages.
    if is_root
      # We need to grab all the other liquid files in the dir and add them as
      # child pages
      for entry in Dir.glob("#{page.directory}/*.liquid")
        if File.basename(entry) != 'index.liquid'
          child_page = load_local_page(entry, page)
          page.children.push child_page
        end
      end
    # Otherwise, see if there is a folder of the same name as the page, then
    # load them as child pages
    else
      child_dir = File.join(File.dirname(path), File.basename(path, '.liquid'))
      if File.exists? child_dir
        Dir.glob("#{child_dir}/*.liquid").each do |file|
          child_page = load_local_page(file, page)
        end
      end
    end
    page
  end


  def self.get_remote_page(page_id)
    # TODO: Should we check the local cache first?
    url = "#{environment['host']}/locomotive/api/pages/#{page_id}.json?"\
            "auth_token=#{token}"
    response = HTTParty.get url

    if response.code == 200 && !response.body.nil? && !response.body.empty?
      return JSON.parse response.body
    else
      # fail WagonException
    end
  end

  def self.create_remote_page(page)
    # TODO
  end

  def self.update_remote_page(page)
    #TODO
  end



end