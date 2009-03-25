#
# Cookbook Name:: monit
# Recipe:: default
#

remote_file "/engineyard/bin/monit_merb_bot" do
  source "merb_monit_bot"
  owner "root"
  group "root"
  mode 0755
end

#TODO: generate the monitrc file