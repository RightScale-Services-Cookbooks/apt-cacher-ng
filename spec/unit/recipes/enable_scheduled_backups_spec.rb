#
# Cookbook Name:: rsc_apt-cacher-ng
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'apt-cacher-ng::enable_scheduled_backups' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['apt-cacher-ng']['backup']['lineage'] = 'testing'
        node.set['apt-cacher-ng']['backup']['schedule']['hour'] = '10'
        node.set['apt-cacher-ng']['backup']['schedule']['minute'] = '30'
      end.converge(described_recipe)
    end
    let(:lineage) { chef_run.node['apt-cacher-ng']['backup']['lineage'] }

    it 'creates a crontab entry' do
      expect(chef_run).to create_cron("backup_schedule_#{lineage}").with(
        minute: chef_run.node['apt-cacher-ng']['backup']['schedule']['minute'],
        hour: chef_run.node['apt-cacher-ng']['backup']['schedule']['hour'],
        command: "rs_run_recipe --policy 'apt-cacher-ng::backup' --name 'apt-cacher-ng::backup'"
      )
    end

    context 'apt-cacher-ng/schedule/hour or apt-cacher-ng/schedule/minute missing' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.set['apt-cacher-ng']['backup']['lineage'] = 'testing'
          node.set['apt-cacher-ng']['backup']['schedule']['hour'] = '10'
        end.converge(described_recipe)
      end
      let(:lineage) { chef_run.node['apt-cacher-ng']['backup']['lineage'] }
      
      it 'raises an error' do
        expect { chef_run }.to raise_error(
                                 RuntimeError,
                                 'apt-cacher-ng/backup/schedule/hour and apt-cacher-ng/backup/schedule/minute inputs should be set'
                               )
      end
    end
end
