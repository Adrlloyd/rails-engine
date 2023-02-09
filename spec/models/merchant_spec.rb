require 'rails_helper'

RSpec.describe Merchant, type: :model do 

  describe 'validation' do
    it { should validate_presence_of :name }
  end 

  describe 'relationships' do
    it { should have_many :items }
  end

  it 'returns a merchant given a search input' do
      merchant1 = create(:merchant, name: 'Turing')
      merchant2 = create(:merchant, name: 'Ring World')
      

      expect(Merchant.find_one('ring')).to eq(merchant2)
    end
end