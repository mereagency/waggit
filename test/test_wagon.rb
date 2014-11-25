require 'minitest/autorun'
require_relative '../lib/wagon.rb'

class WagonTest < MiniTest::Test

  def test_wagon_path_exists
    dir = Dir.pwd
    Dir.chdir "test_site" do 
      assert_equal "#{dir}/test_site", Waggit::Wagon.get_wagon_path
    end
  end

  def test_wagon_path_not_exists
    assert_equal nil, Waggit::Wagon.get_wagon_path
  end

  def test_get_site_file_exists
    dir = Dir.pwd 
    Dir.chdir "test_site" do 
      assert_equal "#{dir}/test_site/config/site.yml", Waggit::Wagon.get_site_file
    end
  end

  def test_get_site_file_not_exists
    assert_equal nil, Waggit::Wagon.get_site_file
  end

  def test_get_deploy_file_exists
    dir = Dir.pwd 
    Dir.chdir "test_site" do 
      assert_equal "#{dir}/test_site/config/deploy.yml", Waggit::Wagon.get_deploy_file
    end
  end

  def test_get_deploy_file_not_exists
    assert_equal nil, Waggit::Wagon.get_deploy_file
  end

  def test_get_pages_dir_exists
    dir = Dir.pwd
    Dir.chdir 'test_site' do
      assert_equal "#{dir}/test_site/app/views/pages", Waggit::Wagon.get_pages_dir
    end
  end

  def test_get_pages_dir_not_exists
    assert_equal nil, Waggit::Wagon.get_pages_dir
  end

  def test_get_index_page_file_exists
    dir = Dir.pwd 
    Dir.chdir "test_site" do 
      assert_equal "#{dir}/test_site/app/views/pages/index.liquid", Waggit::Wagon.get_index_page_file
    end
  end

  def test_get_index_page_file_not_exists
    assert_equal nil, Waggit::Wagon.get_index_page_file
  end
end
