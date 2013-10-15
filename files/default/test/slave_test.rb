#
# Author:: TANABE Ken-ichi (<nabeken@tknetworks.org>)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'minitest/spec'

describe_recipe 'nsd_test::slave' do
  it 'initialzes nsd.db' do
    file(node['nsd']['db'])
    .must_exist
    .with(:owner, 'root')
    .and(:group, 'wheel')
    .and(:mode, 0644)
  end

  it 'configures nsd' do
    service('nsd').must_be_running

    file(node['nsd']['conf'])
    .with(:owner, node['nsd']['user'])
    .and(:group, node['nsd']['group'])
    .and(:mode, 0600)

[%Q{
zone:
        name: example.com.
        allow-notify: 127.0.0.1 NOKEY
        request-xfr: 127.0.0.2 NOKEY
        zonefile: "secondary/zone_example.com."},

%Q{
zone:
        name: example.org.
        allow-notify: 127.0.0.3 NOKEY
        allow-notify: 127.0.0.4 NOKEY
        request-xfr: 127.0.0.5 NOKEY
        request-xfr: 127.0.0.6 NOKEY
        zonefile: "secondary/zone_example.org."},

%Q{
zone:
        name: example.net.
        allow-notify: 127.0.0.7 NOKEY
        allow-notify: 127.0.0.8 NOKEY
        request-xfr: 127.0.0.9 NOKEY
        request-xfr: 127.0.0.10 NOKEY
        zonefile: "secondary/zone_example.net."}].each do |z|
      file(node['nsd']['conf'])
      .must_include(z)
    end
  end
end
