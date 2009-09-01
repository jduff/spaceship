require 'behaviors/base'
require 'behaviors/seek'
require 'behaviors/pursue'
require 'behaviors/flee'
require 'behaviors/evade'
require 'behaviors/wander'
class Ship < Chingu::GameObject
  attr_accessor :vel_x, :vel_y, :steering
  
  def initialize
    super(:image=>Image["Starfighter.bmp"], :zorder=>ZOrder::Ship, :factor=>0.75)

    @vel_x = 0.0
    @vel_y = 0.0
  end
  
  def warp(loc_x, loc_y)
    # @pos.x, @pos.y = x, y
    self.x = loc_x
    self.y = loc_y
  end
  
  def angle=(val)
    @angle = val
  end
  
  def update(time)
    super(time)
    validate_position!
    
    @steering.calculate(time, self) if @steering
    self.x += @vel_x
    self.y += @vel_y
  
    return self
  end
  
  def validate_position!
    self.x %= SCREEN_WIDTH
    self.y %= SCREEN_HEIGHT
  end
  
  def fire
    Bullet.new(:x=>self.x, :y=>self.y, :angle=>self.angle)
  end

end

class Bullet < Chingu::GameObject
  def initialize(options={})
    super({:image=>Image["burst.png"], :zorder=>ZOrder::Ship, :factor=>0.3}.merge(options))
  end
  
  def update(time)
    super
    @factor_x = rand * 0.3
    vect = (angle - 90).angle_to_vect * 2.5
    self.x += vect.x
    self.y += vect.y
  end
end