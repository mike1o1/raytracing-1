require_relative "vector3d"
require_relative "point"
require_relative "utilities/utilities"

class Camera
  include Utilities

  attr_reader :look_from
  attr_reader :look_at
  attr_reader :v_up
  attr_reader :vertical_fov
  attr_reader :aspect_ratio
  attr_reader :height
  attr_reader :width
  attr_reader :focal_length
  attr_reader :aperture
  attr_reader :focus_dist
  attr_reader :w
  attr_reader :u
  attr_reader :v

  def initialize(look_from, look_at, options = {})
    @look_from = look_from
    @look_at = look_at

    @v_up = options[:v_up] || Vector3d.new(0, 1, 0)
    @vertical_fov = options[:vertical_fov] || 90.0
    @aspect_ratio = options[:aspect_ratio] || 16.0 / 9.0
    @height = options[:height] || 2.0 * Math.tan(theta / 2.0)
    @width = options[:width] || aspect_ratio * height
    @focal_length = options[:focal_length] || 1.0
    @aperture = options[:aperture] || 0.0
    @focus_dist = options[:focus_dist] || 1.0

    set_coordinate_instance_vars
  end

  def get_ray(s, t)
    offset_vector = Vector3d.random_in_unit_disk * lens_radius
    offset = u * offset_vector.x + v * offset_vector.y

    Ray.new(origin + offset, ray_direction(s, t, offset))
  end

  def image_dimensions(image_width)
    [image_width, (image_width / aspect_ratio).to_i]
  end

  private

  def ray_direction(s, t, offset = nil)
    direction = lower_left + horizontal * s + vertical * t - origin
    return direction if offset.nil?

    direction - offset
  end

  def set_coordinate_instance_vars
    @w = (look_from - look_at).unit_vector
    @u = v_up.cross(w).unit_vector
    @v = w.cross(u)
  end

  def origin
    look_from
  end

  def horizontal
    u * width * focus_dist
  end

  def vertical
    v * height * focus_dist
  end

  def lower_left
    origin - (horizontal / 2.0) - (vertical / 2.0) - (w * focus_dist)
  end

  def lens_radius
    aperture / 2.0
  end

  def theta
    degrees_to_radians(vertical_fov)
  end
end
