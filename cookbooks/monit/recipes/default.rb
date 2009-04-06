#
# Cookbook Name:: monit
# Recipe:: default
#

execute "rm-mongrel_merb.*.monitrc-file" do
  command %Q{
    rm /etc/monit.d/rm-mongrel_merb.#{node[:monit][:application]}.monitrc
  }

  not_if { not File.exists? "/etc/monit.d/rm-mongrel_merb.#{node[:monit][:application]}.monitrc"}
end

template "/etc/monit.d/merb_mongrels.*.monitrc" do
  owner 'root'
  group 'root'
  mode 0644
  source "merb_mongrel.monitrc.erb"
  variables(node[:monit])
end

template "/etc/monit.d/merb_script.*.monitrc" do
  owner 'root'
  group 'root'
  mode 0644
  source "merb_script.monitrc.erb"
  variables(node[:monit])
end

execute "reload-monit" do
  command %Q{
    /usr/bin/monit reload
  }
end