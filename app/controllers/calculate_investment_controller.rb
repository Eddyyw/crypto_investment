# frozen_string_literal: true

# Controller for calculate the investment
class CalculateInvestmentController < ApplicationController
  def index
    render :index, locals: current_crypto_data
  end

  def calculate_projection
    projection = ProjectionService.new(params_permite[:amount].to_i).call

    render json: { data: projection }, status: 200
  end

  def print_projection
    csv = ProjectionCsvGenerator.new(params).generate

    respond_to do |format|
      format.csv do
        send_data csv, content_type: 'text/csv'
      end
    end
  end

  private

  def params_permite
    params.permit(:amount)
  end

  def current_crypto_data
    CurrentCryptoPriceService.new.call
  end
end
