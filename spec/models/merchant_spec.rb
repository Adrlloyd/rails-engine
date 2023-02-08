require 'rails_helper'

RSpec.describe Merchant, type: :model do 

  describe 'validation' do
    it { should validate_presence_of :name }
  end 

  describe 'relationships' do
    it { should have_many :items }
  end
end