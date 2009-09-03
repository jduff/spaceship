class Bullet < Chingu::GameObject
  def initialize(options={})
    @creator = options.delete(:creator)
    super({:image=>Image["burst.png"], :zorder=>ZOrder::Ship, :factor=>0.3, :factor_x=>0.1}.merge(options))
  end
  
  def update
    super
    @factor_x = rand * 0.3
    vect = (angle - 90).angle_to_vect * 2.5
    self.x += vect.x
    self.y += vect.y
    
    destroy! if outside_window?
    
    $window.game_objects_of_class(Ship).each do |ship|
      if Gosu::distance(@x, @y, ship.x, ship.y) < 20 && ship != @creator
        self.destroy!
        ship.collide(5)
      end
    end
  end
end