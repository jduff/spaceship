# Convenience methods for convertions
class Numeric
  # assumes the number is in degrees
  def to_rads
    Float(self*(Math::PI/180))
  end
end