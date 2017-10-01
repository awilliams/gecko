require 'gecko'
require 'rspec'

Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

Faraday.default_adapter = :test

RSpec::Matchers.define :be_a_valid_payload do |api_key, data|
  def payload(api_key, data)
    {:api_key => api_key, :data => data}
  end
  match do |actual|
    actual.kind_of?(Hash) && actual == payload(api_key, data)
  end
  failure_message do |actual|
    "expected that\n#{actual.inspect}\nwould be\n#{payload(api_key, data).inspect}"
  end
end

# Thanks https://gist.github.com/1428875
class MockBlock
  def to_proc
    lambda { |*a| call(*a) }
  end
end