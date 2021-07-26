class Vector3d
  attr_accessor :x
  attr_accessor :y
  attr_accessor :z

  def initialize(x = 0.0, y = 0.0, z = 0.0)
    @x = x.to_f
    @y = y.to_f
    @z = z.to_f
  end

  def +(other)
    self.class.new(x + other.x, y + other.y, z + other.z)
  end

  def -(other)
    self.class.new(x - other.x, y - other.y, z - other.z)
  end

  def *(other)
    case other
    when Vector3d
      self.class.new(x * other.x, y * other.y, z * other.z)
    else
      self.class.new(x * other, y * other, z * other)
    end
  end

  def /(other)
    self * (1.to_f / other)
  end

  def -@
    self.class.new(-x, -y, -z)
  end

  def length
    Math.sqrt(length_squared)
  end

  def length_squared
    x ** 2 + y ** 2 + z ** 2
  end

  def to_s
    "#{x} #{y} #{z}"
  end

  def dot(other)
    (x * other.x) + (y * other.y) + (z * other.z)
  end

  def cross(other)
    self.class.new(y * other.z - z * other.y,
      z * other.x - x * other.z,
      x * other.y - y * other.x)
  end

  def unit_vector
    self / length
  end

  def near_zero?
    s = 1e-8

    [x, y, z].all? { |dimension| dimension < s }
  end

  def self.random_unit_vector
    Vector3d.random_in_unit_sphere.unit_vector
  end

  def self.random_in_unit_sphere
    loop do
      vector = Vector3d.random(-1.0, 1.0)

      return vector if vector.length_squared < 1
    end
  end

  def self.random_in_unit_disk
    loop do
      vector = Vector3d.random(-1.0, 1.0)
      vector.z = 0.0
      return vector if vector.length_squared < 1
    end
  end

  def self.random_in_hemisphere(normal)
    in_unit_sphere = Vector3d.random_in_unit_sphere

    if in_unit_sphere.dot(normal) > 0.0
      in_unit_sphere
    else
      -in_unit_sphere
    end
  end

  def self.random(*args)
    case args.reject(&:nil?).count
    when 0
      Vector3d.new(rand, rand, rand)
    when 2
      min, max = args.map(&:to_f)
      Vector3d.new(rand(min..max), rand(min..max), rand(min..max))
    else
      nil
    end

  end
end
