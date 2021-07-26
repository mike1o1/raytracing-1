require_relative "./lib/vector3d"
require_relative "./lib/image"
require_relative "./lib/ray"
require_relative "./lib/sphere"
require_relative "./lib/point"
require_relative "./lib/world"
require_relative "./lib/camera"
require_relative "./lib/materials/lambertian"
require_relative "./lib/materials/metal"
require_relative "./lib/materials/dielectric"

ASPECT_RATIO = 16.0 / 9.0
IMAGE_WIDTH = 1024
IMAGE_HEIGHT = (IMAGE_WIDTH / ASPECT_RATIO).to_i

def random_scene
  # Set up the world
  world = World.new

  # Add the three basic spheres
  left_material = Materials::Lambertian.new(Color.new(0.4, 0.2, 0.1))
  left_sphere = Sphere.new(Point.new(-4.0, 1.0, 0.0), 1.0, left_material)

  center_material = Materials::Dielectric.new(1.5)
  center_sphere = Sphere.new(Point.new(0.0, 1.0, 0.0), 1.0, center_material)

  right_material = Materials::Metal.new(Color.new(0.7, 0.6, 0.5))
  right_sphere = Sphere.new(Point.new(4.0, 1.0, 0.0), 1.0, right_material)

  [left_sphere, center_sphere, right_sphere].each { |sphere| world.add(sphere) }

  (-11..11).each do |a|
    (-11..11).each do |b|
      material_probability = rand
      center = Point.new(a + 0.9 * rand, 0.2, b + 0.9 * rand)

      # Check it's not too far away
      next unless (center - Point.new(4, 0.2, 0)).length > 0.9

      # Make a material based on probability
      if material_probability < 0.8
        # Lambertian
        albedo = Color.random * Color.random
        material = Materials::Lambertian.new(albedo)
      elsif material_probability < 0.95
        # Metal
        albedo = Color.random(0.5, 1.0)
        fuzz = rand(0.0..0.5)
        material = Materials::Metal.new(albedo, fuzz)
      else
        # Glass
        material = Materials::Dielectric.new(1.5)
      end

      # Add the sphere to the world
      sphere = Sphere.new(center, 0.2, material)
      # world.add(sphere)
    end
  end

  # Add the ground
  ground_material = Materials::Lambertian.new(Color.white * 0.5)
  ground_sphere = Sphere.new(Point.new(0, -1000, 0), 1000, ground_material)
  world.add(ground_sphere)

  world
end

class Main
  VIEWPORT_HEIGHT = 2.0
  VIEWPORT_WIDTH = ASPECT_RATIO * VIEWPORT_HEIGHT

  attr_accessor :viewport_height
  attr_accessor :viewport_width
  attr_accessor :focal_length

  attr_accessor :origin
  attr_accessor :horizontal
  attr_accessor :vertical
  attr_accessor :lower_left_corner

  def render
    world = random_scene

    camera = Camera.new(
      Point.new(13, 3, 2),
      Point.new(0, 0, 0),
      vertical_fov: 20,
      aspect_ratio: 3.0 / 2.0,
      aperture: 0.1,
      focus_dist: 10.0
    )

    image = Image.new(IMAGE_WIDTH, IMAGE_HEIGHT, camera, world)
    image.render
  end
end

Main.new.render
