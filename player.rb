class Player < Ship
  attr_reader :score

  def initialize
    super
    @score = 0
  end
  
  def turn_left
    # new_angle = (@heading.angle-94)
    # @heading.x = Float(Math::cos(new_angle.to_rads))
    # @heading.y = Float(Math::sin(new_angle.to_rads))
    rotate(-4.0)
  end
  
  def turn_right
    rotate(4.0)
    # new_angle = (@heading.angle-86)
    # @heading.x = Float(Math::cos(new_angle.to_rads))
    # @heading.y = Float(Math::sin(new_angle.to_rads))
  end
  
  def accelerate
    # @vel.x += Gosu::offset_x(@heading.angle, 0.5)
    # @vel.y += Gosu::offset_y(@heading.angle, 0.5)
    @vel_x += Gosu::offset_x(angle, 0.5)
    @vel_y += Gosu::offset_y(angle, 0.5)
  end
  
  def reverse
    # @vel.x -= Gosu::offset_x(@heading.angle, 0.5)
    # @vel.y -= Gosu::offset_y(@heading.angle, 0.5)
    @vel_x -= Gosu::offset_x(angle, 0.5)
    @vel_y -= Gosu::offset_y(angle, 0.5)
  end
  
  def update
    super
    # @x += @vel_x
    # @y += @vel_y
    # # @pos.x += @vel.x
    # # @pos.y += @vel.y
    # # 
    @vel_x *=0.95
    @vel_y *=0.95
    
    self.collect_stars
    
    return self
  end
  
  def collect_stars
    $window.game_objects_of_class(Star).each do |star|
      if Gosu::distance(@x, @y, star.x, star.y) < 35
        @score += 10
        star.destroy!
      end
    end
  end
end