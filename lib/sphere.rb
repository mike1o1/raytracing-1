require_relative "hittable"

class Sphere < Hittable
  attr_reader :center
  attr_reader :radius
  attr_reader :material

  def initialize(center, radius, material)
    @center = center
    @radius = radius
    @material = material
  end

  def hit?(ray, t_min, t_max, hit_record)
    oc = ray.origin - center
    a = ray.direction.length_squared
    half_b = oc.dot(ray.direction)
    c = oc.length_squared - (radius ** 2)
    discriminant = (half_b ** 2) - (a * c)

    return false if discriminant.negative?

    sqrtd = Math.sqrt(discriminant)

    # Find the nearest root that lies in the acceptable range
    root = (-half_b - sqrtd) / a
    if root < t_min || t_max < root
      root = (-half_b + sqrtd) / a

      if root < t_min || t_max < root
        return false
      end
    end

    hit_record.t = root
    hit_record.point = ray.at(hit_record.t)
    hit_record.material = material

    outward_normal = (hit_record.point - center) / radius
    hit_record.set_face_normal(ray, outward_normal)

    true
  end
end
