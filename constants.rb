SCREEN_WIDTH  = 640
SCREEN_HEIGHT = 480

DT            = (1.0/60.0)
DAMPING       = 0.8

PLAYER_INPUT = {:holding_left=>:turn_left, :holding_right=>:turn_right,
                :holding_up=>:accelerate, :holding_down=>:reverse, :holding_a=>:turn_left,
                :holding_d=>:turn_right, :holding_w=>:accelerate, :holding_s=>:reverse}

module ZOrder
  Background, Stars, Ship, UI = *0..3
end