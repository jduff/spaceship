class Ship
  attr_reader :pos, :vel, :heading,
  :mass, :max_speed, :color, :max_force, :max_turn_rate, :evader
  def initialize(window)
    @image = Gosu::Image.new(window, "media/Starfighter.bmp", false)
    @beep = Gosu::Sample.new(window, "media/Beep.wav")
    
    @pos = Vector2d.new(0,0)
    @accel = Vector2d.new
    @vel = Vector2d.new
    @heading = Vector2d.new(0,-1)
    @mass = Float(1)
    @max_speed = Float(150)
    @max_force = Float(100)
    @max_turn_rate = Float(180)
    @steering = SteeringBehaviors.new(self)
    # @steering.behaviors[:wander] = true
  end
  
  def pursue(obj)
    @evader = obj
    @steering.behaviors[:pursuit] = true
  end
  
  def warp(x, y)
    @pos.x, @pos.y = x, y
  end
  
  def speed
    @vel.length
  end

  def side
    @heading.perp
  end
  
  def update(time)
    @force = @steering.calculate
    @accel = @force / @mass
    @accel.truncate!(@max_force)

    rads = Math::PI / 180
    new_velocity = @vel + @accel * time / 1000.0
    @angle = Vector2d.angle(@heading, new_velocity) * rads
    max_angle = (@max_turn_rate * rads  / 1000.0) * time
    
    if @angle.abs > max_angle
      sign = Vector2d.sign(@heading, new_velocity)
      corrected_angle = @heading.radians + max_angle * sign
      @vel.x = Math.sin(corrected_angle) * new_velocity.length
      @vel.y = - Math.cos(corrected_angle) * new_velocity.length
    else
      @vel = new_velocity
    end
    
    @vel.truncate!(@max_speed)
    @pos += @vel * time / 1000.0

    if @vel.length_sq > 0.0001
      @heading = @vel.normalize
    end
    return self
  end
  
  def validate_position!
    @pos.x %= SCREEN_WIDTH
    @pos.y %= SCREEN_HEIGHT
  end

  def draw
    @image.draw_rot(@pos.x, @pos.y, ZOrder::Ship, @heading.angle, 0.5, 0.5, 0.75, 0.75)
  end
end