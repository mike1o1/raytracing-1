class Ray
  attr_accessor :origin
  attr_accessor :direction

  def initialize(origin, direction)
    @origin = origin
    @direction = direction
  end

  def at(t)
    origin + (direction * t)
  end

  def unit_vector
    direction.unit_vector
  end
end
