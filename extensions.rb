# Convenience methods for convertions
class Numeric
  # assumes the number is in degrees
  def to_rads
    Float(self*(Math::PI/180))
  end
  
  def angle_to_vect
    Vector2d.new(Float(Math::cos(self.to_rads)), Float(Math::sin(self.to_rads)))
  end
end