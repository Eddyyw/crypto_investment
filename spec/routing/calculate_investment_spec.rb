# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateInvestmentController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: root_path).to route_to('calculate_investment#index')
    end

    it 'routes to #calculate' do
      expect(post: '/calculate').to route_to('calculate_investment#calculate_projection')
    end

    it 'routes to #print_projection' do
      expect(post: '/print_projection').to route_to(
        {
          'format' => 'csv',
          'controller' => 'calculate_investment',
          'action' => 'print_projection'
        }
      )
    end

    it 'routes to #projection' do
      expect(get: '/projection').to route_to('calculate_investment#calculate_projection')
    end
  end
end
