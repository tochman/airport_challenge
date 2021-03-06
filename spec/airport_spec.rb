require 'airport'
require 'plane'

describe Airport do
  subject { Airport.new Plane}
  let(:plane) { subject.planes.first }
  
  it {is_expected.to respond_to :current_weather?}
  it {is_expected.to respond_to :can_land?}
  it {is_expected.to respond_to :full?}
  it {is_expected.to respond_to :can_take_off?}
  it {is_expected.to respond_to :release_plane}
  it {is_expected.to respond_to :receive_plane}
  
  describe 'take off' do
    before(:each) do
      allow(plane).to receive(:landed?).and_return(true)
      allow(subject).to receive(:can_take_off?).and_return(true)
    end

    it 'instructs a plane to take off' do
      expect(plane.take_off(subject)).to eq 'Took off'
    end

    it 'releases a plane' do 
      plane.take_off(subject)
      expect(subject.planes).to_not include plane
    end       
  end

  describe 'landing' do   
    before(:each) do
      allow(plane).to receive(:flying?).and_return(true)
      allow(subject).to receive(:can_land?).and_return(true)
    end
    
    it 'instructs a plane to land' do
      expect(plane.land(subject)).to eq 'Landed'
    end

    it 'receives a plane' do 
      plane.land(subject)
      expect(subject.planes).to include plane
    end
  end

  describe 'traffic control' do
    
    it '#full? returns false if not full' do 
      allow(subject.planes).to receive(:count).and_return(2)
      expect(subject).to_not be_full
    end
    
    it '#full? returns true if full' do 
      allow(subject.planes).to receive(:count).and_return(Airport::MAX_CAPACITY)
      expect(subject).to be_full
    end
    
    context 'when airport is full' do
      before(:each) do
        allow(subject).to receive(:full?).and_return(true)
        allow(subject).to receive(:current_weather?).and_return(:sunny)
      end
      
      it 'does not allow a plane to land' do 
        expect{plane.land(subject)}.to raise_error 'Not allowed to land'
      end
    end
    
    context 'when airport is not full' do
      before(:each) do
        allow(plane).to receive(:flying?).and_return(true)
        allow(subject).to receive(:full?).and_return(false)
        allow(subject).to receive(:current_weather?).and_return(:sunny)
      end
      
      it 'allows a plane to land' do 
        expect(plane.land(subject)).to eq 'Landed'
      end
    end

    context 'when weather conditions are stormy' do
     
      before(:each) do
        allow(plane).to receive(:flying?).and_return(false)
        allow(subject).to receive(:current_weather?).and_return(:stormy)
      end
      it 'does not allow a plane to take off' do
        expect{plane.take_off(subject)}.to raise_error 'Not allowed to take off'
      end

      it 'does not allow a plane to land' do
         expect{plane.land(subject)}.to raise_error 'Not allowed to land'
      end
    end
    
    it '#current_weather? returns :sunny or :stormy' do
      weather = []
      100.times do
        weather << subject.current_weather?
      end
      expect(weather).to include :sunny 
      expect(weather).to include :stormy
      
    end
  end
  
end
