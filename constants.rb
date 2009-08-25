SCREEN_WIDTH  = 640
SCREEN_HEIGHT = 480

DT            = (1.0/60.0)
DAMPING       = 0.8

PLAYER_INPUT = {:left=>:turn_left, :right=>:turn_right, :up=>:accelerate, :down=>:reverse,
                :a=>:turn_left, :d=>:turn_right, :w=>:accelerate, :s=>:reverse}

module ZOrder
  Background, Stars, Ship, UI = *0..3
end