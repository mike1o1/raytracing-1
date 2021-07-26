class Color < Vector3d
  MAX = 255.999

  alias r x
  alias g y
  alias b z

  def to_s
    rgb.map { |v| (v * MAX).to_i.to_s }.join(" ") + "\n"
  end

  def rgb
    [r, g, b]
  end

  def self.white
    Color.new(1.0, 1.0, 1.0)
  end

  def self.black
    Color.new(0.0, 0.0, 1.0)
  end
end
