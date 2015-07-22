#
# Cookbook Name:: apt-cacher-ng
# Recipe:: default
#
# Copyright (c) 2015 Rightscale, Inc. All Rights Reserved.
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

marker 'recipe_start_rightscale' do
  template "rightscale_audit_entry.erb"
end

node.set['apt']['cacher_dir'] = node['apt-cacher-ng']['cache']['dir']
node.set['apt']['caching_server'] = true
include_recipe 'apt::cacher-ng'

# Setup server to use its own cache
include_recipe 'apt::cacher-client'
