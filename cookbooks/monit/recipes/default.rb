#
# Cookbook Name:: monit
# Recipe:: default
#

execute "rm-mongrel_merb.#{node[:monit][:application]}.monitrc-file" do
  command %Q{
    rm /etc/monit.d/rm-mongrel_merb.#{node[:monit][:application]}.monitrc
  }
end

remote_file "/etc/monit.d/mashtags.mongrels.monitrc" do
  source "mashtags.mongrels.monitrc"
  owner "root"
  group "root"
  mode 0644
end

remote_file "/etc/monit.d/mashtags.script.monitrc" do
  source "mashtags.script.monitrc"
  owner 'root'
  group 'root'
  mode 0644
end

execute "reload-monit" do
  command %Q{
    /usr/bin/monit reload
  }
end