class Evade < Flee
  def initialize(target)
    super(target)
    @pursuing_vehicle = target
  end
  
  def calculate(time, object)  
    to_pursuer = Vector2d(@pursuing_vehicle) - Vector2d(object)
    pursuer_vel = Vector2d.new(@pursuing_vehicle.vel_x, @pursuing_vehicle.vel_y)
    
    look_ahead_time = to_pursuer.length / (@max_speed + pursuer_vel.length)
    @target = Vector2d(@pursuing_vehicle) + pursuer_vel * look_ahead_time 
    
    super
  end
end