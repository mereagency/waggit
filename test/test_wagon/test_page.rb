require 'minitest/autorun'
require_relative '../../lib/wagon/page.rb'

class Waggit::Wagon::WagonPageTest < MiniTest::Test

  def test_load_local_index_page
    Dir.chdir("../test_site") do 
      index_path = Waggit::Wagon.get_index_page_file
      page = Waggit::Wagon::Page.load_local_page(index_path)
      assert_equal "index", page.slug
      assert_equal index_path, page.filepath
      assert_equal "Home page", page.title
      assert_equal true, page.listed
      assert_equal "none", page.cache_strategy
      assert_equal "text/html", page.response_type
      assert_equal 0, page.position
      assert_equal true, page.is_root
      assert_equal nil, page.parent
      refute_equal nil, page.children
      # FIXME: Once there is a more definite structure to the page contents,
      # this should validate children pages, at least names or something.
    end
  end
end