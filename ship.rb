require 'behaviors/base'
require 'behaviors/seek'
require 'behaviors/pursue'
require 'behaviors/flee'
require 'behaviors/evade'
class Ship < Chingu::GameObject
  attr_accessor :vel_x, :vel_y, :steering
  
  def initialize
    super(:image=>Image["Starfighter.bmp"], :zorder=>ZOrder::Ship)

    # @steering = SteeringBehaviors.new(Vehicle.new(self))
    
    @vel_x = 0.0
    @vel_y = 0.0
  end
  
  # def pursue(obj)
  #   @evader = obj
  #   @steering.behaviors[:pursuit] = true
  # end
  
  def warp(loc_x, loc_y)
    # @pos.x, @pos.y = x, y
    @x, @y = loc_x, loc_y
  end
  
  def x=(val)
    @x = val
  end
  
  def y=(val)
    @y=val
  end
  
  def angle=(val)
    @angle = val
  end
  
  def update(time)
    super(time)
    @steering.calculate(time, self) if @steering
    @x += @vel_x
    @y += @vel_y
    
    validate_position!
    
    return self
  end
  
  def validate_position!
    @x %= SCREEN_WIDTH
    @y %= SCREEN_HEIGHT
  end

  def draw
    super
    # @image.draw_rot(@pos.x, @pos.y, ZOrder::Ship, @heading.angle, 0.5, 0.5, 0.75, 0.75)
  end
end