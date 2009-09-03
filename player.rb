class Player < Ship
  attr_reader :score

  def initialize
    super
    @score = 0
  end
  
  def turn_left
    rotate(-3.0)
  end
  
  def turn_right
    rotate(3.0)
  end
  
  def accelerate
    @vel_x += Gosu::offset_x(angle, 0.2)
    @vel_y += Gosu::offset_y(angle, 0.2)
  end
  
  def reverse
    @vel_x -= Gosu::offset_x(angle, 0.1)
    @vel_y -= Gosu::offset_y(angle, 0.1)
  end
  
  def update
    super
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