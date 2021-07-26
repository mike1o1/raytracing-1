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
require "byebug"

ASPECT_RATIO = 16.0 / 9.0
IMAGE_WIDTH = 75
IMAGE_HEIGHT = (IMAGE_WIDTH / ASPECT_RATIO).to_i

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
    world = World.new

    mat_ground = Materials::Lambertian.new(Color.new(0.8, 0.8, 0.0))
    mat_center = Materials::Lambertian.new(Color.new(0.1, 0.2, 0.5))

    mat_left = Materials::Dielectric.new(1.5)
    mat_right = Materials::Metal.new(Color.new(0.8, 0.6, 0.2), 0.0)

    world.add(Sphere.new(Point.new(0.0, -100.5, -1.0), 100.0, mat_ground))
    world.add(Sphere.new(Point.new(0.0, 0.0, -1.0), 0.5, mat_center))
    world.add(Sphere.new(Point.new(-1.0, 0.0, -1.0), 0.5, mat_left))
    world.add(Sphere.new(Point.new(-1.0, 0.0, -1.0), -0.45, mat_left))
    world.add(Sphere.new(Point.new(1.0, 0.0, -1.0), 0.5, mat_right))

    camera = Camera.new(
      Point.new(-2, 2, 1),
      Point.new(0, 0, -1),
      v_up: Vector3d.new(0, 1, 0),
      vertical_pov: 20,
      aspect_ratio: 2.0,
      aperture: 0.1,
      focus_dist: 10.0
    )

    image = Image.new(IMAGE_WIDTH, IMAGE_HEIGHT, camera, world)
    image.render
  end

end

Main.new.render
