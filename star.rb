class Star < Chingu::Actor
  attr_reader :x, :y
  
  def initialize(animation)
    super(:x=>rand * SCREEN_WIDTH, :y=>rand*SCREEN_HEIGHT, :color=>Gosu::Color.new(0xff000000))
    @animation = animation
    @color.red = rand(255 - 40) + 40
    @color.green = rand(255 - 40) + 40
    @color.blue = rand(255 - 40) + 40
  end

  def draw  
    # super
    img = @animation[Gosu::milliseconds / 100 % @animation.size]
    img.draw(x - img.width / 2.0, y - img.height / 2.0,
        ZOrder::Stars, 1, 1, color, :additive)
  end
end