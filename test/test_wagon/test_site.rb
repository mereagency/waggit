require 'minitest/autorun'
require_relative '../../lib/wagon/site.rb'

class Waggit::Wagon::WagonSiteTest < MiniTest::Test

  def test_create_site
    Dir.chdir "../test_site" do 
      site = Waggit::Wagon::Site.new
      refute_nil site
      assert_equal "Waggit Test Engine", site.name
      assert_equal ["en"], site.locales
      assert_equal site.environments, {"production"=>{"host"=>"http://localhost:8080", "email"=>"test.waggit@gmail.com", "password"=>"test.password", "api_key"=>"068ea9b0183816c25c000209688227bca53569b4"}}
    end
  end

  def test_create_site_wrong_path
    # This should throw an exception since we don't point it at the right 
    # site file
    assert_raises(Waggit::Wagon::WagonFileException) do
      Waggit::Wagon::Site.new
    end
  end

  def test_get_site_token
    Dir.chdir "../test_site" do 
      site = Waggit::Wagon::Site.new
      assert_equal 'evQZ6aupeeewxi1hx4u1', site.token
    end
  end

  def test_get_site_token_err
    site = nil
    Dir.chdir "../test_site" do 
      site = Waggit::Wagon::Site.new
    end
    # FIXME
    #assert_raise_exception site.get_token, WagonTokenException
  end

  def test_get_site_remote_info
    Dir.chdir "../test_site" do 
      site = Waggit::Wagon::Site.new
      info = site.remote_info
      assert_equal '545bf94c46b5b6f84a000002', info['id']
      assert_equal 'Waggit Test Engine', info['name']
      assert_equal 'example.com', info['domain_name']
   end
  end

  def test_get_site_remote_info_fail
    # TODO
  end

  def test_get_site_pages
    Dir.chdir '../test_site' do
      site = Waggit::Wagon::Site.new
      for key, page in site.remote_pages
        refute_nil page.slug
        refute_nil page.title
        refute_nil page.id
        refute_nil page._id
        refute_nil page.created_at
        refute_nil page.updated_at
        refute_nil page.parent_id unless page.root? #all but the index have this
        refute_nil page.position
        refute_nil page.response_type
        refute_nil page.cache_strategy
        refute_nil page.redirect
        refute_nil page.redirect_type
        refute_nil page.listed
        refute_nil page.published
        refute_nil page.templatized
        refute_nil page.templatized_from_parent
        refute_nil page.fullpath
        refute_nil page.localized_fullpaths
        refute_nil page.depth
        refute_nil page.translated_in
        refute_nil page.raw_template
        refute_nil page.editable_elements
      end
    end
  end

  def test_get_site_pages_fail
    # TODO
  end

  def test_local_pages
     Dir.chdir '../test_site' do
      site = Waggit::Wagon::Site.new      
      for page in site.local_pages
        #puts "page.slug: #{page.slug}"
        refute_nil page.slug
        refute_nil page.title
        refute_nil page.response_type
        refute_nil page.cache_strategy
        refute_nil page.listed
        refute_nil page.published
        refute_nil page.fullpath
        refute_nil page.raw_template
      end
    end
  end

  def test_get_remote_page
    # TODO
  end

  def test_create_page
    # TODO
  end

  def test_edit_page
    # TODO
  end

  def test_remove_page
    # TODO
  end


end