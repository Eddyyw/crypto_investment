# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateInvestmentController, type: :request do
  before do
    btc_request
    eth_request
    ada_request
  end

  describe '#index' do
    it 'render index' do
      get root_path

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:index)
      expect(response.body).to include 'Get your projections!'
    end
  end

  describe '#calculate_projection' do
    it 'render json projection' do
      post calculate_path(amount: 100)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data'][0]).to include 'month_number'
      expect(JSON.parse(response.body)['data'][0]).to include 'btc_amount'
      expect(JSON.parse(response.body)['data'][0]).to include 'eth_amount'
      expect(JSON.parse(response.body)['data'][0]).to include 'ada_amount'
    end
  end

  describe '#print_projection' do
    it 'render csv' do
      post print_projection_path(
        format: :csv,
        btc_data: {
          symbol: 'BTC',
          price: 26_618.029010150512
        },
        eth_data: {
          symbol: 'ETH',
          price: 1_630.8803053012182
        },
        ada_data: {
          symbol: 'ADA',
          price: 0.25022713995424417
        }
      )

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(
        'Month;BTC - 26618.029010150512;ETH - 1630.8803053012182;ADA - 0.25022713995424417'
      )
    end
  end

  private

  def btc_request
    btc_body = {
      data: {
        symbol: 'BTC',
        name: 'Bitcoin',
        market_data: {
          price_usd: 26_618.029010150512
        }
      }
    }

    stub_request(:get, 'https://rest.coinapi.io/v1/exchangerate/BTC/USD')
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Host' => 'data.coinapi.io',
          'User-Agent' => 'rest-client/2.1.0 (darwin22 arm64) ruby/3.1.2p20'
        }
      ).to_return(status: 200, body: btc_body.to_json)
  end

  def eth_request
    eth_body = {
      data: {
        symbol: 'ETH',
        name: 'Ethereum',
        market_data: {
          price_usd: 1_630.8803053012182
        }
      }
    }

    stub_request(:get, 'https://rest.coinapi.io/v1/exchangerate/ETH/USD')
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Host' => 'data.coinapi.io',
          'User-Agent' => 'rest-client/2.1.0 (darwin22 arm64) ruby/3.1.2p20'
        }
      ).to_return(status: 200, body: eth_body.to_json)
  end

  def ada_request
    ada_body = {
      data: {
        symbol: 'ADA',
        name: 'Cardano',
        market_data: {
          price_usd: 0.25022713995424417
        }
      }
    }

    stub_request(:get, 'https://rest.coinapi.io/v1/exchangerate/ADA/USD')
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Host' => 'data.coinapi.io',
          'User-Agent' => 'rest-client/2.1.0 (darwin22 arm64) ruby/3.1.2p20'
        }
      ).to_return(status: 200, body: ada_body.to_json)
  end
end
