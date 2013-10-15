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
require 'spec_helper'

describe 'nsd_test::slave' do
  include_context 'openbsd'

  let (:chef_run) {
    ChefSpec::Runner.new(step_into: %w{nsd_zone}) do |node|
      set_node(node)
    end
  }

  shared_examples_for 'as slave' do
    it 'should configure nsd' do
      conf = chef_run.node['nsd']['conf']
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
      expect(chef_run)
      .to render_file(conf)
      .with_content(z)
      end

      expect(chef_run.template(conf)).to notify('service[nsd]').to(:restart)
    end
  end

  context 'with fresh install' do
    before do
      ::File.stub(:exists?).and_call_original
      ::File.stub(:exists?).with('/var/nsd/db/nsd.db').and_return(false)
      chef_run.converge('nsd_test::slave')
    end

    it 'should rebuild a database' do
      expect(chef_run).to run_execute('nsdc rebuild')
    end

    it_behaves_like 'as slave'
  end

  context 'with installed' do
    before do
      ::File.stub(:exists?).and_call_original
      ::File.stub(:exists?).with('/var/nsd/db/nsd.db').and_return(true)
      chef_run.converge('nsd_test::slave')
    end

    it 'should not rebuild a database' do
      expect(chef_run).not_to run_execute('nsdc rebuild')
    end

    it_behaves_like 'as slave'
  end
end
