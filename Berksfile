site :opscode

metadata

%w{
  chef-openbsd
}.each do |c|
  cookbook c, git: "git://github.com/tknetworks-cookbooks/#{c}.git", branch: 'fullspec'
end

group :integration do
  cookbook 'apt'
  cookbook 'minitest-handler'

  %w{
  }.each do |c|
    cookbook c, git: "git://github.com/tknetworks-cookbooks/#{c}.git"
  end

  cookbook 'nsd_test', :path => './test/cookbooks/nsd_test'
end
