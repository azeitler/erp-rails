# == Schema Information
#
# Table name: plans
#
#  id                :bigint           not null, primary key
#  name              :string           not null
#  amount            :integer          default(0), not null
#  interval          :string           not null
#  details           :jsonb            not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  trial_period_days :integer          default(0)
#  hidden            :boolean
#  currency          :string
#  interval_count    :integer          default(1)
#  description       :string
#  unit_label        :string
#  charge_per_unit   :boolean
#  stripe_id         :string
#  braintree_id      :string
#  paddle_billing_id :string
#  paddle_classic_id :string
#  lemon_squeezy_id  :string
#  fake_processor_id :string
#  contact_url       :string
#
class Plan < ApplicationRecord
  has_prefix_id :plan

  store_accessor :details, :features, :stripe_tax
  attribute :currency, default: "usd"
  normalizes :currency, with: ->(currency) { currency.downcase }

  validates :name, :amount, :interval, presence: true
  validates :currency, presence: true, format: {with: /\A[a-zA-Z]{3}\z/, message: "must be a 3-letter ISO currency code"}
  validates :interval, inclusion: %w[month year]
  validates :trial_period_days, numericality: {only_integer: true}
  validates :unit_label, presence: {if: :charge_per_unit?}

  scope :hidden, -> { where(hidden: true) }
  scope :visible, -> { where(hidden: [nil, false]) }
  scope :monthly, -> { where(interval: :month) }
  scope :yearly, -> { where(interval: :year) }
  scope :sorted, -> { order(amount: :asc) }

  # Returns a free plan for the Fake Processor
  def self.free
    plan = where(name: "Free").first_or_initialize
    plan.update(hidden: true, amount: 0, currency: :usd, interval: :month, trial_period_days: 0, fake_processor_id: :free)
    plan
  end

  def features
    Array.wrap(super)
  end

  def has_trial?
    trial_period_days > 0
  end

  def monthly?
    interval == "month"
  end

  def annual?
    interval == "year"
  end
  alias_method :yearly?, :annual?

  def stripe_tax=(value)
    super(ActiveModel::Type::Boolean.new.cast(value))
  end

  def taxed?
    ActiveModel::Type::Boolean.new.cast(stripe_tax)
  end

  # Find a plan with the same name in the opposite interval
  # This is useful when letting users upgrade to the yearly plan
  def find_interval_plan
    monthly? ? annual_version : monthly_version
  end

  def annual_version
    return self if annual?
    self.class.yearly.where(name: name).first
  end
  alias_method :yearly_version, :annual_version

  def monthly_version
    return self if monthly?
    self.class.monthly.where(name: name).first
  end

  def id_for_processor(processor_name, currency: "usd")
    return if processor_name.nil?
    processor_name = :braintree if processor_name.to_s == "paypal"
    send(:"#{processor_name}_id")
  end
end
