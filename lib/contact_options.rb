# frozen_string_literal: true

require_relative 'generate_ranking_and_contact_options'
require 'debug'
require 'json'

class ContactOptions
  NAME = 'name'

  def self.call(...)
    new(...).call
  end

  def initialize(response:)
    @records = JSON.parse(response)
  end

  def call
    @records = GenerateRankingAndContactOptions.call(@records)
    @records.sort_by! { |record| last_name(record) + first_name(record) + middle_name(record) }
    puts @records.to_json
  end

  private

  def first_name(record)
    record[NAME].split(/ /).first
  end

  def last_name(record)
    record[NAME].split(/ /).last
  end

  def middle_name(record)
    return record[NAME].split(/ /)[1] if record[NAME].split(/ /).count > 2

    ''
  end
end
