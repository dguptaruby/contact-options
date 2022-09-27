# frozen_string_literal: true

require 'debug'
require 'json'

class GenerateRankingAndContactOptions
  BASE_RANKING = 3
  CONTACT_OPTION = 'contact_option'
  EMAIL = 'email'
  FREE = 'free'
  INTROS_OFFERRED = 'introsOffered'
  PERSONAL_EMAIL = %w[gmail.com hotmail.com outlook.com].freeze
  RANKING = 'ranking'
  RANKING_FOR_NOT_HAVING_PERSONAL_EMAIL = 2
  VIP = 'vip'

  def self.call(...)
    new(...).call
  end

  def initialize(records)
    @records = records
  end

  def call
    records_with_ranking = merge_ranking_to_records
    merge_contact_options_to_records(JSON.parse(records_with_ranking))
  end

  private

  attr_accessor :records

  def merge_ranking_to_records
    records.map do |record|
      record.merge({ "#{RANKING.downcase}": calculated_ranking(record) })
    end.to_json
  end

  def calculated_ranking(record)
    BASE_RANKING + (personal_email?(record) ? 0 : RANKING_FOR_NOT_HAVING_PERSONAL_EMAIL) +
      (intro_offered(record) * 1)
  end

  def personal_email?(record)
    PERSONAL_EMAIL.include? record[EMAIL].split(/@/).last
  end

  def intro_offered(record)
    record[INTROS_OFFERRED][FREE] + record[INTROS_OFFERRED][VIP]
  end

  def merge_contact_options_to_records(records)
    contacts = []
    contact_without_vip_intro_and_with_highest_ranking = contact_without_vip_intro_and_with_highest_ranking(records)
    contacts << contact_without_vip_intro_and_without_highest_ranking(records,
                                                                      contact_without_vip_intro_and_with_highest_ranking)
    contacts << contact_with_one_or_more_vip_intro(records)
    contacts << contact_without_vip_intro_and_with_highest_ranking.merge({ "#{CONTACT_OPTION.downcase}": VIP.capitalize })
    contacts.flatten
  end

  def contact_without_vip_intro_and_with_highest_ranking(records)
    filtered_records = records.select do |record|
      record[INTROS_OFFERRED][VIP].zero?
    end

    filtered_records.sort_by! { |record| record[RANKING] }.last
  end

  def contact_without_vip_intro_and_without_highest_ranking(records, record_with_highest_ranking)
    filtered_records = records.reject { |record| [record_with_highest_ranking].include? record }

    merge_contact_options_as_free(filtered_records)
  end

  def contact_with_one_or_more_vip_intro(records)
    filtered_records = records.reject { |record| record[INTROS_OFFERRED][VIP].zero? }

    merge_contact_options_as_free(filtered_records)
  end

  def merge_contact_options_as_free(filtered_records)
    filtered_records.map do |record|
      record.merge({ "#{CONTACT_OPTION.downcase}": FREE })
    end
  end
end
