require 'behaviors/base'
require 'behaviors/seek'
require 'behaviors/pursue'
require 'behaviors/flee'
require 'behaviors/evade'
require 'behaviors/wander'
class Ship < Chingu::Actor
  attr_accessor :vel_x, :vel_y
  
  def initialize
    super(:image=>Image["Starfighter.bmp"], :zorder=>ZOrder::Ship, :factor=>0.75)
    @damage = 100
    @vel_x = 0.0
    @vel_y = 0.0
  end
  
  def warp(loc_x, loc_y)
    self.x = loc_x
    self.y = loc_y
  end
  
  def angle=(val)
    @angle = val
  end
  
  def update
    super
    validate_position!
    self.x += @vel_x
    self.y += @vel_y
  
    return self
  end
  
  def validate_position!
    self.x %= SCREEN_WIDTH
    self.y %= SCREEN_HEIGHT
  end
  
  def fire
    Bullet.new(:x=>self.x, :y=>self.y, :angle=>self.angle, :creator=>self)
  end
  
  def collide(damage)
    @damage -= damage
    destroy! if @damage <= 0
  end

end