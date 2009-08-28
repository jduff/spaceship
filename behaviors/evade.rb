class Evade < Flee
  def initialize(target)
    super(0,0)
    @pursuing_vehicle = target
  end
  
  def calculate(time, object)  
    to_pursuer = Vector2d.new(@pursuing_vehicle.x, @pursuing_vehicle.y) - Vector2d.new(object.x, object.y)
    pursuer_vel = Vector2d.new(@pursuing_vehicle.vel_x, @pursuing_vehicle.vel_y)
    
    look_ahead_time = to_pursuer.length / (@max_speed + pursuer_vel.length)
    @target = Vector2d.new(@pursuing_vehicle.x, @pursuing_vehicle.y) + pursuer_vel * look_ahead_time 
    
    super
  end
end