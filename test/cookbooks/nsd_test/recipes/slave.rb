#
# Author:: Ken-ichi TANABE (<nabeken@tknetworks.org>)
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
nsd_zone 'example.com.' do
  type 'slave'
  allow_notify %w{127.0.0.1}
  request_xfr %w{127.0.0.2}
end

nsd_zone 'example.org.' do
  type 'slave'
  allow_notify %w{127.0.0.3 127.0.0.4}
  request_xfr %w{127.0.0.5 127.0.0.6}
end

node.set['nsd']['zones']['example.net.'] = {
  'type' => 'slave',
  'allow-notify' => %w{127.0.0.7 127.0.0.8},
  'request-xfr' => %w{127.0.0.9 127.0.0.10},
}

include_recipe 'nsd::slave'
