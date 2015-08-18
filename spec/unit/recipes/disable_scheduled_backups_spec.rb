#
# Cookbook Name:: rsc_apt-cacher-ng
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'apt-cacher-ng::disable_scheduled_backups' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['apt-cacher-ng']['schedule']['enable'] = false
        node.set['apt-cacher-ng']['backup']['lineage'] = 'testing'
      end.converge(described_recipe)
    end
    let(:lineage) { chef_run.node['apt-cacher-ng']['backup']['lineage'] }

    it 'deletes a crontab entry' do
      expect(chef_run).to delete_cron("backup_schedule_#{lineage}").with(
        command: "rs_run_recipe --policy 'apt-cacher-ng::backup' --name 'apt-cacher-ng::backup'"
      )
    end
end
