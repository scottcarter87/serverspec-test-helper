#
# Cookbook Name:: serverspec_test_helper
# Recipe:: default
#
# Copyright (C) 2014
#
# All rights reserved - Do Not Redistribute
#
chef_gem 'activesupport'

require 'pathname'
require 'active_support/core_ext/hash/deep_merge'

package 'curl'

directory node['serverspec_test_helper']['json']['dir'] do
  recursive true
end

# Set the fully qualified path to the file.
filename = "#{node['serverspec_test_helper']['json']['dir']}/#{node['serverspec_test_helper']['json']['file']}"

file filename do
  owner 'root'
  mode '0400'
end

log "Dumping attributes to #{filename}."

ruby_block 'dump_node_attributes' do
  block do
    require 'json'

    attrs = {}

    attrs = attrs.deep_merge(node.default_attrs) unless node.default_attrs.empty?
    attrs = attrs.deep_merge(node.normal_attrs) unless node.normal_attrs.empty?
    attrs = attrs.deep_merge(node.override_attrs) unless node.override_attrs.empty?
    attrs = attrs.deep_merge(node.automatic_attrs) unless node.automatic_attrs.empty?

    recipe_json = "{ \"run_list\": \[ "
    recipe_json << node.run_list.expand(node.chef_environment).recipes.map! { |k| "\"#{k}\"" }.join(",")
    recipe_json << " \] }"
    attrs = attrs.deep_merge(JSON.parse(recipe_json))

    File.open(filename, 'w') { |file| file.write(JSON.pretty_generate(attrs)) }
  end
end
