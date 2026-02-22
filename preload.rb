module Input
  module Controller
    def self.connected?
      false
    end

    def self.name
      ""
    end

    def self.power_level
      :UNKNOWN
    end

    def self.axes_left
      [0.0, 0.0]
    end

    def self.axes_right
      [0.0, 0.0]
    end

    def self.axes_trigger
      [0.0, 0.0]
    end

    def self.raw_button_states
      []
    end

    def self.raw_axes
      []
    end

    def self.pressex?(button)
      false
    end

    def self.triggerex?(button)
      false
    end

    def self.repeatex?(button)
      false
    end

    def self.releaseex?(button)
      false
    end

    def self.repeatcount(button)
      0
    end

    def self.timeex?(button)
      0.0
    end
  end
end
