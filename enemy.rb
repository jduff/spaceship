# require 'behaviors/base'
# require 'behaviors/seek'
# require 'behaviors/pursue'
# require 'behaviors/flee'
# require 'behaviors/evade'
# require 'behaviors/wander'

class Enemy < Ship
  # attr_accessor :steering
  
  attr_reader :target, :mass, :max_speed, :max_force, :max_turn_rate
  
  def initialize()
    super
    # default_opts = {
    #   :x => 0,
    #   :y => 0,
    #   :mass => 1,
    #   :color => 0xffffffff,
    #   :max_speed => 150,
    #   :max_force => 500,
    #   :max_turn_rate => 160
    # }
    # opts = default_opts.merge!(opts)

    
    # @target = @evader = @pursuer = nil
    # @vel = Vector2d.new
    # @accel = Vector2d.new
    # @heading = Vector2d.new(0,-1)
    
    # @pos = Vector2d.new(opts[:x], opts[:y])
    @mass = Float(1)
    # @color = opts[:color]
    @max_speed = Float(150)
    @max_force = Float(100)
    @max_turn_rate = Float(160)
    
    
    @steering = SteeringBehaviors.new(self)
  end
  
  def vel
    Vector2d.new(vel_x, vel_y)
  end
  
  def pos
    Vector2d.new(x,y)
  end
  
  def heading
    (self.angle-90).angle_to_vect
  end
  
  def seek(x, y)
    activate(:seek)
    @target = Vector2d.new(x, y)
  end
  
  def activate(behavior)
    @steering.activate(behavior)
  end

  def deactivate(behavior)
    @steering.deactivate(behavior)
  end

  def update
    super
    @force = @steering.calculate
    @accel = @force / @mass
    @accel.truncate!(@max_force)
    elapsed_t = $window.dt

    rads = Math::PI / 180
    new_velocity = vel + @accel * elapsed_t
    new_angle = Vector2d.angle(heading, new_velocity) * rads
    max_angle = @max_turn_rate * rads * elapsed_t
    
    if new_angle.abs > max_angle
      sign = Vector2d.sign(heading, new_velocity)
      corrected_angle = heading.radians + max_angle * sign
      velocity = Vector2d.new(Math.sin(corrected_angle) * new_velocity.length, Math.cos(corrected_angle) * new_velocity.length)
    else
      velocity = new_velocity
    end
    
    velocity.truncate!(@max_speed)
    # @pos = pos + @vel * elapsed_t
    self.vel_x = self.x + velocity.x * elapsed_t
    self.vel_y = self.y + velocity.y * elapsed_t

    if velocity.length_sq > 0.0001
      @heading = velocity.normalize
      self.angle = @heading.angle
    end
    
    # self.x=@pos.x
    # puts @pos.x
    puts self.vel_x
    puts x
    # self.vel_y=@pos.y
    
    # @steering.calculate($window.dt, self) if @steering
    

    
    # $window.game_objects_of_class(Ship).each do |ship|
    #   target_pos = Vector2d(ship)
    # 
    #   to_evader = target_pos - Vector2d(self)
    # 
    #   object_heading = self.angle.angle_to_vect
    #   evader_heading = ship.angle.angle_to_vect
    # 
    #   relative_heading = object_heading.dot(evader_heading)
    #   puts("fire") if to_evader.dot(object_heading) > 0 && relative_heading < -0.95
    #   self.fire if to_evader.dot(object_heading) > 0 && relative_heading < -0.95 && rand(100) < 10
    # end
    
    return self
  end

end