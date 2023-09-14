# frozen_string_literal: true

# Service for the projection
class ProjectionService
  BTC_INSTEREST_PERCENTAGE = 0.05
  ETH_INSTEREST_PERCENTAGE = 0.042
  ADA_INSTEREST_PERCENTAGE = 0.01

  def initialize(amount)
    @amount = amount
    @crypto_data = CurrentCryptoPriceService.new.call
  end

  def call
    projection_values
  end

  private

  attr_accessor :amount, :crypto_data

  def projection_values
    btc_amount = amount / crypto_data[:btc_data][:price_usd]
    eth_amount = amount / crypto_data[:eth_data][:price_usd]
    ada_amount = amount / crypto_data[:ada_data][:price_usd]

    money_values(btc_amount, eth_amount, ada_amount)
  end

  def money_values(btc_amount, eth_amount, ada_amount)
    (1..12).each_with_object([]) do |element, values|
      btc_interest = (btc_amount * BTC_INSTEREST_PERCENTAGE)
      eth_interest = (eth_amount * ETH_INSTEREST_PERCENTAGE)
      ada_interest = (ada_amount * ADA_INSTEREST_PERCENTAGE)

      values << {
        month_number: element,
        btc_amount: btc_amount =+ btc_amount + btc_interest,
        eth_amount: eth_amount =+ eth_amount + eth_interest,
        ada_amount: ada_amount =+ ada_amount + ada_interest
      }
    end
  end
end
