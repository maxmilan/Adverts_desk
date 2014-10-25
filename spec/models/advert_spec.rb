require 'rails_helper'

RSpec.describe Advert, type: :model do

  let(:advert){FactoryGirl.build(:advert)}
  let(:user){advert.user}

  it 'should be valid' do
    expect(advert).to be_valid
  end

  it 'should delete advert' do
    advert.destroy
    expect(user.adverts.include?(advert)).not_to eq(true)
  end

  it 'should be invalid without title' do
    advert.title = nil
    expect(advert).not_to be_valid
    advert.title = ''
    expect(advert).not_to be_valid
  end

  it 'should be invalid without body' do
    advert.body = nil
    expect(advert).not_to be_valid
    advert.body = ''
    expect(advert).not_to be_valid
  end

  it 'should have category' do
    advert.category = nil
    expect(advert).not_to be_valid
  end

  it 'should have normal price' do
    advert.price = -1
    expect(advert).not_to be_valid
  end

  it 'should have correct type' do
    expect(advert).to be_valid
    advert.advert_type = 'unknown'
    expect(advert).not_to be_valid
  end

  describe 'Advert states' do
	  it 'should have state new' do
	    expect(advert.new?).to eq(true)
	  end

	  it 'should be waiting' do
	    [:new, :archive].each do |state|
	      advert.state = state
	      advert.wait
	      expect(advert.waiting?).to eq(true)
	    end
	  end

	  it 'should archivate each advert' do
	    [:new, :waiting, :published, :rejected].each do |state|
	      advert.state = state
	      advert.send_to_archive
	      expect(advert.archive?).to eq(true)
	    end
	  end
	end

  describe 'Advert accept/reject' do
		before{advert.wait}
	  it 'should have rejected reason' do
	    advert.reject
	    advert.reject_reason = nil
	    expect(advert).not_to be_valid
	    advert.reject_reason = ''
	    expect(advert).not_to be_valid
	  end

	  it 'should accept waiting advert' do
	    advert.accept
	    expect(advert.published?).to eq(true)
	  end

	  it 'should reject waiting advert' do
	    advert.reject
	    expect(advert.rejected?).to eq(true)
	  end
	end
end