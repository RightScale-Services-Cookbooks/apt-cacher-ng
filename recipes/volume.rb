#
# Cookbook Name:: rsc_apt-cacher-ng
# Recipe:: volume
#
# Copyright (C) 2015 RightScale, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

marker "recipe_start_rightscale" do
  template "rightscale_audit_entry.erb"
end

include_recipe 'rightscale_volume::default'
include_recipe 'rightscale_backup::default'

detach_timeout = node['apt-cacher-ng']['device']['detach_timeout'].to_i
device_nickname = node['apt-cacher-ng']['device']['nickname']
size = node['apt-cacher-ng']['device']['volume_size'].to_i

execute "set decommission timeout to #{detach_timeout}" do
  command "rs_config --set decommission_timeout #{detach_timeout}"
  not_if "[ `rs_config --get decommission_timeout` -eq #{detach_timeout} ]"
end


# Cloud-specific volume options
volume_options = {}
volume_options[:iops] = node['apt-cacher-ng']['device']['iops'] if node['apt-cacher-ng']['device']['iops']
volume_options[:volume_type] = node['apt-cacher-ng']['device']['volume_type'] if node['apt-cacher-ng']['device']['volume_type']
volume_options[:controller_type] = node['apt-cacher-ng']['device']['controller_type'] if node['apt-cacher-ng']['device']['controller_type']

new_cache_dir = "#{node['apt-cacher-ng']['device']['mount_point']}/apt-cacher-ng"

# apt-cacher-ng/restore/lineage is empty, creating new volume
if node['apt-cacher-ng']['restore']['lineage'].to_s.empty?
  log "Creating a new volume '#{device_nickname}' with size #{size}"
  rightscale_volume device_nickname do
    size size
    options volume_options
    action [:create, :attach]
  end

  filesystem device_nickname do
    fstype node['apt-cacher-ng']['device']['filesystem']
    device lazy { node['rightscale_volume'][device_nickname]['device'] }
    mkfs_options node['apt-cacher-ng']['device']['mkfs_options']
    mount node['apt-cacher-ng']['device']['mount_point']
    action [:create, :enable, :mount]
  end
# apt-cacher-ng/restore/lineage is set, restore from the backup
else
  node.override['apt-cacher-ng']['lineage'] = node['apt-cacher-ng']['restore']['lineage']
  lineage = node['apt-cacher-ng']['restore']['lineage']
  timestamp = node['apt-cacher-ng']['restore']['timestamp']

  message = "Restoring volume '#{device_nickname}' from backup using lineage '#{lineage}'"
  message << " and using timestamp '#{timestamp}'" if timestamp

  log message

  rightscale_backup device_nickname do
    lineage node['apt-cacher-ng']['restore']['lineage']
    timestamp node['apt-cacher-ng']['restore']['timestamp'].to_i if node['apt-cacher-ng']['restore']['timestamp']
    size size
    options volume_options
    action :restore
  end

  directory node['apt-cacher-ng']['device']['mount_point'] do
    owner 'root'
    group 'root'
    mode 0755
    recursive true
    action :create
  end

  mount node['apt-cacher-ng']['device']['mount_point'] do
    fstype node['apt-cacher-ng']['device']['filesystem']
    device lazy { node['rightscale_backup'][device_nickname]['devices'].first }
    action [:mount, :enable]
  end
end

directory new_cache_dir do
  owner 'apt-cacher-ng'
  group 'apt-cacher-ng'
  mode 0755
  action :create
end

directory node['apt-cacher-ng']['cache']['dir'] do
  recursive true
  action :delete
end

link node['apt-cacher-ng']['cache']['dir'] do
  to new_cache_dir
end
