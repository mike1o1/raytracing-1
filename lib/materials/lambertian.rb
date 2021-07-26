require_relative "base_material"
require_relative "../vector3d"
require_relative "../ray"

module Materials
  class Lambertian < BaseMaterial
    def initialize(albedo)
      @albedo = albedo
    end

    def scatter?(ray, hit_record)
      scatter_direction = hit_record.normal + Vector3d.random_unit_vector

      scatter_direction = hit_record.normal if scatter_direction.near_zero?

      @scattered = Ray.new(hit_record.point, scatter_direction)
      @attenuation = albedo

      true
    end
  end
end
