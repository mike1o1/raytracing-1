class HitRecord
  attr_accessor :point
  attr_accessor :normal
  attr_accessor :t
  attr_accessor :front_face
  attr_accessor :material

  def initialize(point = nil, normal = nil, t = nil, material = nil)
    @point = point
    @normal = normal
    @t = t
    @front_face = false
    @material = material
  end

  def set_face_normal(ray, outward_normal)
    @front_face = ray.direction.dot(outward_normal).negative?
    @normal = front_face ? outward_normal : -outward_normal
  end
end

class Hittable
  attr_reader :ray
  attr_reader :t_min
  attr_reader :t_max
  attr_reader :hit_record

  def initialize(ray, t_min, t_max, hit_record = HitRecord.new)
    @ray = ray
    @t_min = t_min
    @t_max = t_max
    @hit_record = hit_record
  end

  def hit?(ray, t_min, t_max, hit_record)
  end
end

class HittableList
  attr_accessor :objects

  def initialize
    clear
  end

  def add(object)
    objects << object
  end

  def clear
    @objects = []
  end

  def hit?(ray, t_min, t_max, hit_record)
    temp_record = HitRecord.new
    hit_anything = false
    closest_so_far = t_max

    objects.each do |object|
      next unless object.hit?(ray, t_min, t_max, temp_record)

      hit_anything = true
      closest_so_far = temp_record.t
      set_hit_from_temp(hit_record, temp_record) if hit_record.t.nil? || closest_so_far <= hit_record.t
    end

    hit_anything
  end

  private

  def set_hit_from_temp(hit_record, temp_record)
    hit_record.instance_variables.each do |symbol|
      variable = symbol.to_s[1, symbol.length]
      setter = variable + "="
      tr_value = temp_record.send(variable)

      hit_record.send(setter, tr_value)
    end
  end
end
