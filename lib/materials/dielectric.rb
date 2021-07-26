require_relative "base_material"

module Materials
  class Dielectric < BaseMaterial
    attr_reader :index_of_refraction

    def initialize(index_of_refraction)
      super(0.0)

      @index_of_refraction = index_of_refraction.to_f
    end

    def scatter?(ray_in, hit_record)
      refraction_ratio = hit_record.front_face ? (1.0 / index_of_refraction) : index_of_refraction

      cos_theta = [(-ray_in.unit_vector).dot(hit_record.normal), 1.0].min
      sin_theta = Math.sqrt(1.0 - cos_theta**2)

      cannot_refract = refraction_ratio * sin_theta > 1.0
      random_reflect = reflectance(cos_theta, refraction_ratio) > rand

      direction = if cannot_refract || random_reflect
        reflect(ray_in.unit_vector, hit_record.normal)
      else
        refract(ray_in.unit_vector, hit_record.normal, refraction_ratio)
      end

      @scattered = Ray.new(hit_record.point, direction)
      @attenuation = Color.white

      true
    end

    private

    def reflectance(cosine, refractive_index)
      r0 = (1.0 - refractive_index) / (1.0 + refractive_index)
      r0 **= 2

      r0 + (1.0 - r0) * (1.0 - cosine)**5
    end
  end
end
