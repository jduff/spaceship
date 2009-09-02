class Bullet < Chingu::GameObject
  def initialize(options={})
    super({:image=>Image["burst.png"], :zorder=>ZOrder::Ship, :factor=>0.3}.merge(options))
  end
  
  def update
    super
    @factor_x = rand * 0.3
    vect = (angle - 90).angle_to_vect * 2.5
    self.x += vect.x
    self.y += vect.y
    
    destroy! if outside_window?
  end
end