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

# This LWRP supports whyrun mode
def whyrun_supported?
  true
end

action :create do
  if new_resource.type == 'slave'
    node.set['nsd']['zones'][new_resource.name] = {
      'allow-notify' => new_resource.allow_notify,
      'request-xfr' => new_resource.request_xfr
    }
  end
end
