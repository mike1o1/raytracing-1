module Materials
  class BaseMaterial
    attr_accessor :albedo
    attr_accessor :scattered
    attr_accessor :attenuation

    def initialize(albedo)
      @albedo = albedo
    end

    def scatter?(*args)
    end

    private

    def reflect(vector, normal)
      vector - (normal * vector.dot(normal)) * 2
    end

    def refract(vector, normal, etai_over_etat)
      cos_theta = [(-vector).dot(normal), 1.0].min
      r_out_perp = (normal * cos_theta + vector) * etai_over_etat
      r_out_parallel = normal * -Math.sqrt((1.0 - r_out_perp.length_squared).abs)

      r_out_perp + r_out_parallel
    end
  end
end
