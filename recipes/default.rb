#
# Cookbook Name:: guards
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Normally this would be defined in the lib directory
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

# Normally this would be defined in the lib directory
Chef::Resource::Execute.include MyCompany::Helpers

execute('database_script') do
  not_if do
    # Using File as a class is hard to use with tests because if you
    # override some of the default behaviors it will cause other issues
    # when other processes like RSpec or Fauxhai load the data.

    # File.exist?('/marker_file')

    # The easier thing is to place a method around it which is easier to stub.
    # This useful in declaring complicated guards more clearly as well.
    marker_file_exists?
  end
end

execute('database_script_2') do
  only_if { database_marker_exist?('please_seed_db') }
end
