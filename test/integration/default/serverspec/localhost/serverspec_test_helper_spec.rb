require 'serverspec'
require 'json'

set :backend, :exec

filename = '/tmp/serverspec/node.json'

# Load all the node attributes
$node = ::JSON.parse(File.read(filename))

describe file(filename) do
  it { should be_file }
end

describe package('curl') do
  it { should be_installed }
end

describe 'Node Attributes' do
  it 'Properly gathers all the node attributes' do
    expect($node['foo']).to eq 'bar'
  end
end