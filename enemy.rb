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
  
  def do_seek(seek_x,seek_y)
    turn_angle = Gosu::angle(x,y,seek_x, seek_y)

    if (turn_angle = Gosu::angle_diff(self.angle, turn_angle)) != 0
      turn_angle = turn_angle*@max_turn_rate/turn_angle.abs if turn_angle.abs > @max_turn_rate

      rotate(turn_angle/($window.dt*2))
    end
    @vel_x = Gosu::offset_x(angle, 0.8)
    @vel_y = Gosu::offset_y(angle, 0.8)
  end
  
  def pursue(evader)
    to_evader = Gosu::distance(evader.x, evader.y, self.x, self.y)
    angle_to_evader = Gosu::angle(self.x, self.y,evader.x, evader.y)
    
    relative_heading = Gosu::angle_diff(self.angle, evader.angle)
    
    if angle_to_evader.abs< 90 && relative_heading.abs > 90
      do_seek(evader.x, evader.y)
    else
      look_ahead_time = to_evader/(self.max_speed + (evader.vel_x**2+evader.vel_y**2))
    
      predicted_x = evader.x + evader.vel_x * look_ahead_time
      predicted_y = evader.y + evader.vel_y * look_ahead_time
    
      do_seek(predicted_x, predicted_y)
    end
  end
  
  # Flee from a target position
  def flee(seek_x,seek_y)
    turn_angle = Gosu::angle(x,y,seek_x, seek_y)-180

    if (turn_angle = Gosu::angle_diff(self.angle, turn_angle)) != 0
      turn_angle = turn_angle*@max_turn_rate/turn_angle.abs if turn_angle.abs > @max_turn_rate

      rotate(turn_angle/($window.dt*2))
    end
    @vel_x = Gosu::offset_x(angle, 0.8)
    @vel_y = Gosu::offset_y(angle, 0.8)
  end
  
  # Evade a pursuer agent
  def evade(pursuer)
    to_pursuer = Gosu::distance(pursuer.x, pursuer.y, self.x, self.y)

    look_ahead_time = to_pursuer/(self.max_speed + (pursuer.vel_x**2+pursuer.vel_y**2))
  
    predicted_x = pursuer.x + pursuer.vel_x * look_ahead_time
    predicted_y = pursuer.y + pursuer.vel_y * look_ahead_time
  
    flee(predicted_x, predicted_y)
  end
  
  # Wander about
  def wander
    wander_jitter = 10
    @wander_x = Gosu::random(x-50, x+50) + Gosu::offset_x(angle, 100)
    @wander_y = Gosu::random(y-50, y+50) + Gosu::offset_y(angle, 100)
    
    puts "x1 #{@wander_x}"
    puts "y1 #{@wander_y}"
    
    # @wander_x = [@wander_x.abs, SCREEN_WIDTH].min
    # @wander_y = [@wander_y.abs, SCREEN_HEIGHT].min
    
    puts "x #{@wander_x}"
    puts "y #{@wander_y}"
    puts "my x #{x}"
    puts "my y #{y}"
    @target = Vector2d.new(@wander_x, @wander_y)
    do_seek(@wander_x, @wander_y)
    

    # wander_jitter = 10
    # 
    # @wander_target += Vector2d.new(clamped_rand * wander_jitter, clamped_rand * wander_jitter)
    # @wander_target.normalize!
    # @wander_angle = @wander_target.angle
    # @wander_target *= wander_radius
    # target_local = @wander_target + Vector2d.new(0, wander_distance)
    # @target_world = Vector2d.point_to_world(target_local, @agent.heading, @agent.side, @agent.pos)
    # 
    # circle_center = Vector2d.new(0, wander_distance)
    # @wander_center = Vector2d.point_to_world(circle_center, @agent.heading, @agent.side, @agent.pos)
    # 
    # return target_world - @agent.pos
  end

  def update
    super
    # wander
    pursue(Player.all.first)
    # flee(@target.x, @target.y)
    # do_seek(@target.x, @target.y)
    # evade(Player.all.first)
    
    
    
    
    # desired_velocity = (target_pos - @agent.pos).normalize * @agent.max_speed
    # return desired_velocity - @agent.vel
    
    # @force = @steering.calculate
    # @accel = @force / @mass
    # @accel.truncate!(@max_force)
    # elapsed_t = $window.dt
    # 
    # rads = Math::PI / 180
    # new_velocity = vel + @accel * elapsed_t
    # new_angle = Vector2d.angle(heading, new_velocity) * rads
    # max_angle = @max_turn_rate * rads * elapsed_t
    # 
    # if new_angle.abs > max_angle
    #   sign = Vector2d.sign(heading, new_velocity)
    #   corrected_angle = heading.radians + max_angle * sign
    #   velocity = Vector2d.new(Math.sin(corrected_angle) * new_velocity.length, Math.cos(corrected_angle) * new_velocity.length)
    # else
    #   velocity = new_velocity
    # end
    # 
    # velocity.truncate!(@max_speed)
    # # @pos = pos + @vel * elapsed_t
    # self.vel_x = self.x + velocity.x * elapsed_t
    # self.vel_y = self.y + velocity.y * elapsed_t
    # 
    # if velocity.length_sq > 0.0001
    #   @heading = velocity.normalize
    #   self.angle = @heading.angle
    # end
    # 
    # # self.x=@pos.x
    # # puts @pos.x
    # puts self.vel_x
    # puts x
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
  
  def draw
    super
    Image['CptnRuby Gem.png'].draw(@target.x, @target.y,100)
  end

end