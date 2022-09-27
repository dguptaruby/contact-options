# frozen_string_literal: true

require 'debug'
require 'json'

class ContactOptions
  ALL_CONTACTS = 'all-contacts'
  RANKING_WITH_CONTACT_OPTIONS = 'ranking-with-contact-options'

  def self.call(...)
    new(...).call
  end

  def initialize(response:, param: ALL_CONTACTS)
    @param = param
    @records ||= JSON.parse(response)
  end

  def call
    case param
    when ALL_CONTACTS
      puts(records.sort_by! { |record| last_name(record) + first_name(record) + middle_name(record) })
    when RANKING_WITH_CONTACT_OPTIONS
      puts RANKING_WITH_CONTACT_OPTIONS
    end
  end

  private

  attr_reader :param, :records

  def first_name(record)
    record['name'].split(/ /).first
  end

  def last_name(record)
    record['name'].split(/ /).last
  end

  def middle_name(record)
    return record['name'].split(/ /)[1] if record['name'].split(/ /).count > 2

    ''
  end
end
