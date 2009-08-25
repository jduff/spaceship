
class KeyboardManager
  
  def initialize(player, window)
    @player = player
    @window = window
  end
  
  def execute
    if @window.button_down?(Gosu::Button::KbA) || @window.button_down?(Gosu::Button::KbLeft)
      @player.turn_left
    end
    if @window.button_down?(Gosu::Button::KbD) || @window.button_down?(Gosu::Button::KbRight)
      @player.turn_right
    end

    if @window.button_down?(Gosu::Button::KbW) || @window.button_down?(Gosu::Button::KbUp)
      @player.accelerate
    elsif @window.button_down?(Gosu::Button::KbS) || @window.button_down?(Gosu::Button::KbDown)
      @player.reverse
    end
  end
end