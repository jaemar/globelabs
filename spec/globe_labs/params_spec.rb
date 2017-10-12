require 'minitest/autorun'
require 'globe_labs'

describe 'GlobeLabs::Params' do
  describe 'encode method' do
    it 'returns a url encoded string containing the given params' do
      params = {app_id: 'key', secret: 'secret', short_code: '1234'}

      GlobeLabs::Params.encode(params).must_equal('app_id=key&secret=secret&short_code=1234')
    end

    it 'flattens array values into multiple key value pairs' do
      params = {'ids' => %w[001A 001B 001C]}

      GlobeLabs::Params.encode(params).must_equal('ids=001A&ids=001B&ids=001C')
    end
  end
end
