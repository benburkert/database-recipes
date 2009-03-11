#
# Cookbook Name:: postgresql
# Recipe:: client
#

package "libpq" do
  version "8.3.1"
  action :install
end