class PpmWriter
  attr_accessor :image_width
  attr_accessor :image_height

  def initialize(image_width = 256, image_height = 256)
    @image_width = image_width
    @image_height = image_height
  end

  def render
    puts "P3\n"
    puts "#{image_width} #{image_height}\n"
    puts "255\n"

    (image_height - 1).downto(0) do |j|
      0.upto(image_width - 1) do |i|
        yield(j, i)
        # color = Vec3.new(i.to_f / (image_width - 1), j.to_f / (image_height - 1), 0.25)
        # color.write_color
      end
    end
  end
end
