#
# Cookbook Name:: guards
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Define the helper methods within a module for namespacing purposes and
# so that we can have the resources that need this functionality to extend it.
#
# NOTE: Normally this would be defined in the libraries directory
#
module MyCompany
  module Helpers
    def marker_file_exists?
      database_marker_exist?('/marker_file')
    end

    def database_marker_exist?(file)
      File.exist?(file)
    end
  end
end

# Ruby classes can include modules; which is like importing methods into the
# instances of this class. In this case, it means that all Execute resources
# would have this helper method available.
# NOTE: This is effects all Execute Resources which is not always desireable.
#
Chef::Resource::Execute.include MyCompany::Helpers

execute('database_script') do
  not_if do
    # Using File as a class is hard to use with tests because if you
    # override some of the default behaviors it will cause other issues
    # when other processes like RSpec or Fauxhai load the data.
    #
    # File.exist?('/marker_file')

    # The easier thing is to place a method around it which is easier to stub.
    # This useful in declaring complicated guards more clearly as well.
    marker_file_exists?
  end
end

execute('database_script_2') do
  # This is a more sophiscated method that allows us to check for a particular
  # file that we specify as a parameter
  only_if { database_marker_exist?('please_seed_db') }
end
