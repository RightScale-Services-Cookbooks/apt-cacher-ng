#
# Cookbook Name:: rsc_apt-cacher-ng
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'apt-cacher-ng::backup' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['chef_handler']['handler_path'] = '/var/chef/handlers'
      node.set['apt-cacher-ng']['backup']['lineage'] = 'testing'
    end.converge(described_recipe)
  end
  let(:nickname) { chef_run.node['apt-cacher-ng']['device']['nickname'] }

  it 'sets up chef error handler' do
    expect(chef_run).to include_recipe('chef_handler::default')
    expect(chef_run).to create_cookbook_file('/var/chef/handlers/apt-cacher-ng_backup.rb').with(
      source: 'backup_error_handler.rb',
    )
    expect(chef_run).to enable_chef_handler('Rightscale::BackupErrorHandler').with(
      source: '/var/chef/handlers/apt-cacher-ng_backup.rb',
    )
  end

  it 'freezes the filesystem' do
    expect(chef_run).to freeze_filesystem("freeze #{nickname}").with(
      label: nickname,
      mount: '/mnt/storage',
    )
  end

  it 'creates a backup' do
    expect(chef_run).to create_rightscale_backup(nickname).with(
      lineage: 'testing',
    )
  end

  it 'unfreezes the filesystem' do
    expect(chef_run).to unfreeze_filesystem("unfreeze #{nickname}").with(
      label: nickname,
      mount: '/mnt/storage',
    )
  end

  it 'cleans up old backups' do
    expect(chef_run).to cleanup_rightscale_backup(nickname).with(
      lineage: 'testing',
      keep_last: 60,
      dailies: 14,
      weeklies: 6,
      monthlies: 12,
      yearlies: 2,
    )
  end
end
