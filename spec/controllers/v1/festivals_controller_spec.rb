require 'rails_helper'


RSpec.describe V1::FestivalsController, :type => :controller do
  describe 'GET #show' do
    context 'when festival_name is not a known festival' do
      it 'raises a "ActionController::RoutingError"' do
        expect{get :show, params: { festival_name: 'Festival inconnu' }}.to raise_error(ActionController::RoutingError)
      end
    end
  end
  
  
  describe 'private function to_slug' do
    context 'when festival_name is standard ("toto")' do
      it 'return an array of 4 rewrited names' do
        toto = controller.send(:to_slug, 'toto')
        expect(toto).to be_an_instance_of(Array)
        expect(toto.count).to eq(5)
        expect(toto).to contain_exactly(
          'toto',
          'toto-2016'
        )
      end
    end
    # context 'when festival_name has spaces ("toto tata")' do
    #   it 'return an array of 4 rewrited names' do
    #     toto = controller.send(:to_slug, 'toto tata')
    #     expect(toto).to be_an_instance_of(Array)
    #     expect(toto.count).to eq(2)
    #     expect(toto).to contain_exactly(
    #       'toto-tata',
    #       'toto-tata-2016'
    #     )
    #   end
    # end
    # context 'when festival_name has Special characters ("T@o\'s táta")' do
    #   it 'return an array of 4 rewrited names' do
    #     toto = controller.send(:to_slug, 'Tot@o\'s táta')
    #     expect(toto).to be_an_instance_of(Array)
    #     expect(toto.count).to eq(2)
    #     expect(toto).to contain_exactly(
    #       'tot-os-t-ta',
    #       'tot-os-t-ta-2016'
    #     )
    #   end
    # end
  end
end