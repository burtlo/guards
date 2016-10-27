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

    context 'when the core marker file is present' do
      before do
        # allow(File).to receive(:exist?).with('/marker_file').and_return(true)
        allow_any_instance_of(Chef::Resource::Execute).to receive(:marker_file_exists?).and_return(true)
      end

      it 'should not execute' do
        resource = chef_run.execute('database_script')
        expect(resource).to do_nothing
      end
    end

    context 'when the core marker file is missing' do
      before do
        # allow(File).to receive(:exist?).with('/marker_file').and_return(false)
        allow_any_instance_of(Chef::Resource::Execute).to receive(:marker_file_exists?).and_return(false)
      end

      it 'should execute' do
        expect(chef_run).to run_execute('database_script')
      end
    end

    context 'when the seed database marker is present' do
      before do
        # While the expectations of this context are not related to this first marker file
        # but it is needed because otherwise the expectations will fail
        allow_any_instance_of(Chef::Resource::Execute).to receive(:marker_file_exists?).and_return(true)
        # Using the with field to ensure that the method is stubbed for only the expected values
        allow_any_instance_of(Chef::Resource::Execute).to receive(:database_marker_exist?).with('please_seed_db').and_return(true)
      end

      it 'should execute' do
        expect(chef_run).to run_execute('database_script_2')
      end
    end

    context 'when the seed database marker is not present' do
      before do
        # While the expectations of this context are not related to this first marker file
        # but it is needed because otherwise the expectations will fail
        allow_any_instance_of(Chef::Resource::Execute).to receive(:marker_file_exists?).and_return(true)
        # Using the with field to ensure that the method is stubbed for only the expected values
        allow_any_instance_of(Chef::Resource::Execute).to receive(:database_marker_exist?).with('please_seed_db').and_return(false)
      end

      it 'should not execute' do
        resource = chef_run.execute('database_script_2')
        expect(resource).to do_nothing
      end
    end

  end
end
