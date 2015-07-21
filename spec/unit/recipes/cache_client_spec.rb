#
# Cookbook Name:: apt-cacher-ng
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'apt-cacher-ng::cache_client' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    before do
      stub_command("grep Acquire::http::Proxy /etc/apt/apt.conf").and_return(true)
    end
    
    it 'includes apt::cacher-client' do
      expect(chef_run).to include_recipe('apt::cacher-client')
    end
  end
end
