class Airport
  attr_accessor :planes
  
  MAX_CAPACITY = 12
  
  def initialize(plane_class)
    @planes = []
    3.times do
      self.planes << plane_class.new
    end
  end
  
  def release_plane(plane)
    self.planes.delete plane
  end
  
  def receive_plane(plane)
    self.planes.push plane 
  end
  
  def can_land?
    current_weather? == :sunny && !self.full?
  end
  alias_method :can_take_off?, :can_land?
  
  def current_weather?
    rand(1..10) <= 7 ? :sunny : :stormy
  end
  
  def full?
    self.planes.count >= MAX_CAPACITY
  end
end
