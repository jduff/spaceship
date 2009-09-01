require 'behaviors/vector2d'
class Base
  def initialize(*args)
    @max_speed = 580 # should be on the vehicle
    @mass = Float(1)
    @max_force = 1200
    @max_turn_rate = 180
  end
  
  def apply(time, object, force)
    # return desired_velocity - current_velocity
    
    # @elapsed_time = elapsed_t
    # 
    vel = Vector2d.new(object.vel_x, object.vel_y)
    
    @force = force
    @accel = @force / @mass
    @accel.truncate!(@max_force)
    
    
    heading = (object.angle-90).angle_to_vect
    
    rads = Math::PI / 180
    new_velocity = vel + @accel * time / 1000.0
    @angle = Vector2d.angle(heading, new_velocity) * rads
    max_angle = (@max_turn_rate * rads  / 1000.0) * time
    
    if @angle.abs > max_angle
      sign = Vector2d.sign(heading, new_velocity)
      corrected_angle = heading.radians + max_angle * sign
      vel.x = Math.sin(corrected_angle) * new_velocity.length
      vel.y = - Math.cos(corrected_angle) * new_velocity.length
    else
      vel = new_velocity
    end
    
    vel.truncate!(@max_speed)
    # @pos += vel * time / 1000.0
    object.vel_x = vel.x * time/200.0
    object.vel_y = vel.y * time/200.0
    
    # object.angle = (vel.angle-object.angle+90)
    
    if vel.length_sq > 0.0001
      heading = vel.normalize
      object.angle = (heading.angle)
      # object.angle = (heading.angle-object.angle)
    else
      # object.angle = (vel.angle - object.angle)
    end
  end
end