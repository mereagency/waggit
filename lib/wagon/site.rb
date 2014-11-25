require_relative '../wagon.rb'
require_relative '../exceptions/wagon_exceptions.rb'
require_relative 'page.rb'

class Waggit::Wagon::Site
  #include HTTParty
  attr_reader :name, :locales, :seo_title, :meta_keywords, :meta_description,
  :environments, :token, :root_page

  # TODO: optionally pass in the info as strings/hash?
  # Then site can be created in memory if it doesn't exist in file system.
  # Is that needed?
  def initialize
    load_site
    load_creds
  end

  def load_site
    site_file = Waggit::Wagon.get_site_file
    fail Waggit::Wagon::WagonFileException unless site_file
    File.open(site_file) do |f|
      site_data = YAML.load(f.read)
      @name = site_data['name']
      @locales = site_data['locales']
      @seo_title = site_data['seo_title']
      @meta_keywords  = site_data['meta_keywords']
      @meta_description = site_data['meta_description']
    end
  end

  def load_creds
    deploy_file = Waggit::Wagon.get_deploy_file
    File.open(deploy_file) do |f|
      environment_data = YAML.load(f.read)
      @environments = environment_data
    end
  end

  def environment
    return @environment if @environment
    # fail WagonUnknownEnvironmentException(environment_name=@@environment_name) unless @environments.include? @@environments
    @environment = @environments[Waggit::Wagon.environment_name]
  end

  def creds
    return @creds if @creds

    if environment.include? 'api_key'
      @creds = {:api_key => environment['api_key']} 
    elsif (environment.include? 'email') && (environment.include? 'password')
      @creds = {:email => environment['email'], :password => environment['password']}
    else
        # fail exception
    end
    # puts creds
    @creds
  end

  def token
    return @token if @token

    url = "#{environment['host']}/locomotive/api/tokens.json"
    # puts url
    response = HTTParty.post(url, query: creds)
    if response.code == 200 && !response.body.nil? && !response.body.empty?
      body = JSON.parse response.body
      if body.include? 'token'
        @token = body['token']
      else
        fail WagonTokenException
      end
    else
      fail WagonTokenException
    end
    @token
  end

  def remote_info(force_retrieve=false)
    return @remote_info if @remote_info && !force_retrieve

    url = "#{environment['host']}/locomotive/api/current_site.json?"\
            "auth_token=#{token}"
    response = HTTParty.get url
    if response.code == 200 && !response.body.nil? && !response.body.empty?
      @remote_info = JSON.parse response.body
    else
      fail WagonException
    end
    @remote_info
  end

  def remote_pages(force_retrieve=false)
    return @remote_pages if @remote_pages && !force_retrieve

    url = "#{environment['host']}/locomotive/api/pages.json?"\
            "auth_token=#{token}"
    response = HTTParty.get url
    if response.code == 200 && !response.body.nil? && !response.body.empty?
      @remote_pages = {}
      @remote_pages_by_id ={}
      remote_page_data = JSON.parse response.body
      for remote_page_data in remote_page_data
        #puts remote_page_data
        remote_page = Waggit::Wagon::Page.new remote_page_data
        @remote_pages[remote_page.fullpath] = remote_page
        @remote_pages_by_id[remote_page.id] = remote_page

        @remote_index_page = remote_page if remote_page.root?
      end

      # We now have remote pages, and can access them by fullpath or by id.
      # We also have the index page, but it has no children. Let's build 
      # the rest of the tree structure using the id/parent_id keys
      def add_page_to_tree(page)
        if !page.root?
          #puts "page: #{page}"
          #puts "page.fullpath: #{page.fullpath}"
          #puts "page.parent_id: #{page.parent_id}"
          page.parent = @remote_pages_by_id[page.parent_id]
          #puts "page.parent: #{page.parent}"
          #puts "page.parent.class: #{page.parent.class}"
          #puts "page.parent.children: #{page.parent.children}"
          page.parent.children << page
        end
      end

      #puts "@remote_pages_by_id: #{@remote_pages_by_id.keys}"
      #puts @remote_pages_by_id.class
      for page in @remote_pages_by_id
        #puts page
        #puts page[0]
        #puts page[1]
        #puts page[0].class
        #puts page[1].class
        #puts page.class
        add_page_to_tree(page[1])
      end

    end
    @remote_pages
  end

  def local_pages
    return @local_pages if @local_pages
    @local_pages = {}

    #pages_dir = Waggit::Wagon.get_pages_dir

    # load the index page. This will load all of its child pages recursively
    @local_index_page = Waggit::Wagon::Page.load_local_page(Waggit::Wagon.get_index_page_file)

    # Load the 404 page. This is not a child of the index, so needs to be loaded independently
    @local_404_page = Waggit::Wagon::Page.load_local_page(Waggit::Wagon.get_404_page_file)
    # Need to create a way to lookup local pages. We are using the fullpath 
    # as the unique key.

    def add_local_page(page)
      @local_pages[page.fullpath] = page
      for child in page.children
        add_local_page child
      end
    end

    add_local_page @local_index_page
    add_local_page @local_404_page
  end
end
