class Wander < Base
  def initialize(options={})
    @options = {:radius=>120.0, :distance=>240.0, :jitter=>10}.merge(options)
    @target = Vector2d.new(clamped_rand, clamped_rand)
    super
  end
  
  def calculate(time, object)

    @target += Vector2d.new(clamped_rand * @options[:jitter], clamped_rand * @options[:jitter])
    @target.normalize!
    @wander_angle = @target.angle
    @target *= @options[:radius]
    target_local = @target + Vector2d.new(0, @options[:distance])
    
    position = Vector2d(object)
    
    target_world = Vector2d.point_to_world(target_local, (object.angle-90).angle_to_vect, (object.angle-90).angle_to_vect.perp, position)

    circle_center = Vector2d.new(0, @options[:distance])
    
    @wander_center = Vector2d.point_to_world(circle_center, object.angle.angle_to_vect, object.angle.angle_to_vect.perp, position)

    
    apply(time,object,target_world - position)
  end
  
  
  
  
  private
  def clamped_rand
    2 * rand - 1
  end
end



