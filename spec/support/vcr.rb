VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.default_cassette_options = {record: :new_episodes} #change to all to update the cassette data
  c.ignore_hosts 'codeclimate.com'
end
