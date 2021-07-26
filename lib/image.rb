require_relative "color"
require_relative "ray"
require_relative "point"
require_relative "vector3d"
require_relative "utilities/utilities"

class Image
  include Utilities

  IMAGE_PATH = "images/image_#{Time.now.to_i}.ppm"
  SAMPLES_PER_PIXEL = 100
  MAX_DEPTH = 50

  attr_reader :image_width
  attr_reader :image_height
  attr_reader :world
  attr_reader :camera

  attr_reader :file

  def initialize(image_width = 256, image_height = 256, camera, world)
    @image_width = image_width
    @image_height = image_height
    @camera = camera
    @world = world

    File.delete(IMAGE_PATH) if File.exists?(IMAGE_PATH)

    @file = nil
  end

  def render
    open

    write("P3\n#{image_width} #{image_height}\n255\n")

    (image_height - 1).downto(0).each do |y|
      (0..image_width - 1).each do |x|
        print "Percent complete: #{percent_complete(x, y)}%\r"

        color = Color.new(0, 0, 0)

        (0..SAMPLES_PER_PIXEL - 1).each do

          u = (x.to_f + rand) / (image_width - 1)
          v = (y.to_f + rand) / (image_height - 1)

          ray = camera.get_ray(u, v)

          color += ray_color(ray)
        end

        write_color(color)
      end
    end
  ensure
    close
  end

  private

  def ray_color(ray, depth = MAX_DEPTH)
    hit_record = HitRecord.new

    if depth <= 0
      return Color.black
    end

    if world.hit?(ray, 0.001, Float::INFINITY, hit_record)
      if hit_record.material.scatter?(ray, hit_record)
        return ray_color(hit_record.material.scattered, depth - 1) * hit_record.material.attenuation
      end

      return Color.black
    end

    t = 0.5 * (ray.unit_vector.y + 1.0)
    Color.white * (1.0 - t) + Color.new(0.5, 0.7, 1.0) * t
  end

  def write_color(color)
    scale = 1.0 / SAMPLES_PER_PIXEL
    scaled_rgb = (color * scale).rgb

    scaled_rgb.map do |value|
      clamp(Math.sqrt(value), 0.0, 0.999)
    end

    scaled_color = Color.new(*scaled_rgb)

    file.write(scaled_color.to_s)
  end

  def open
    @file = File.open(IMAGE_PATH, "a")
  end

  def close
    file.close
  end

  def write(data)
    file.write(data)
  end

  def percent_complete(x, y)
    percent = ((image_height - y) * image_width + x).to_f / (image_height * image_width) * 100

    format("%.4f", percent)
  end
end
