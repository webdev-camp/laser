require 'rspec/core'

RSpec::Core::Runner.run(['spec'])
RSpec.clear_examples
RSpec::Core::Runner.run(['spec' , "--tag" , "ci"])
