# We need to be able to persist certain data. There are number of assumtptions
# we need to take into account:
#
# 1) Waggit needs to be usable by multiple users on an OS, so data needs to be
#    specific to the current user.
# 2) Waggit needs to be usable for multiple sites per user. 
# 3) Waggit cannot be the system of record, the LocomotiveCMS site and git repo
#    function as that. So, the data stored here can only be a cache, and should
#    be easily invalidated, overwritten, and never relied upon without another
#    source to rebuild it.

module Waggit::Storage
  @@root_path = Dir.home + "/.waggit/"

  self.root_storage
    Dir.mkdir @@root_path unless Dir.exists? @@root_path
    Dir.new @@root_path
  end

  self.get_site_storage(site_name)
    # TODO
  end


end 