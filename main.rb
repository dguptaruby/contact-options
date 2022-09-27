# frozen_string_literal: true

require_relative 'lib/contact_options'

response = File.read('sample.json')

ContactOptions.call(response:, param: 'all-contacts')
