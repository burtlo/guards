#
# Cookbook Name:: guards
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'guards::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.7')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    context 'when the marker file is present' do
      before do
        # allow(File).to receive(:exist?).with('/marker_file').and_return(true)
        allow_any_instance_of(Chef::Resource::Execute).to receive(:marker_file_exists?).and_return(true)
      end

      it 'should not execute' do
        resource = chef_run.execute('database_script')
        expect(resource).to do_nothing
      end
    end

    context 'when the marker file is missing' do
      before do
        # allow(File).to receive(:exist?).with('/marker_file').and_return(false)
        allow_any_instance_of(Chef::Resource::Execute).to receive(:marker_file_exists?).and_return(false)
      end

      it 'should execute' do
        expect(chef_run).to run_execute('database_script')
      end
    end

  end
end
