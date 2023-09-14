# frozen_string_literal: true

# Service for the current crypto price
class CurrentCryptoPriceService
  def call
    {
      btc_data: money_values('BTC'),
      eth_data: money_values('ETH'),
      ada_data: money_values('ADA')
    }
  end

  private

  def money_values(money_sym)
    parse_data(money_data(money_sym))
  end

  def money_data(money_sym)
    RestClient::Request.execute(
      method: 'GET',
      url: "https://rest.coinapi.io/v1/exchangerate/#{money_sym}/USD",
      headers: { "X-CoinAPI-Key": '43F0BE16-2859-45F8-9DDC-087C7C92414B' }
    ).body
  rescue RestClient::InternalServerError,
         RestClient::Unauthorized,
         RestClient::BadRequest,
         RestClient::NotFound, RestClient::TooManyRequests => e
    { error: e }.to_json
  end

  def parse_data(body)
    parsed_body = JSON.parse(body)

    return { symbol: '', price_usd: 0, error: parsed_body[:error] } if parsed_body[:error].present?

    {
      symbol: parsed_body['asset_id_base'],
      price_usd: parsed_body['rate']
    }
  end
end
