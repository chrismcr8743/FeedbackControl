classdef signalGenerator
    properties
        amplitude = 1.0
        frequency = 0.001
        y_offset = 0.0
    end

    methods
        function self = signalGenerator(varargin)
            p = inputParser;
            addParameter(p, 'amplitude', 1.0);
            addParameter(p, 'frequency', 0.001);
            addParameter(p, 'y_offset', 0.0);
            parse(p, varargin{:});

            self.amplitude = p.Results.amplitude;
            self.frequency = p.Results.frequency;
            self.y_offset = p.Results.y_offset;
        end

        function out = square(self, t)
            if self.frequency == 0
                out = self.amplitude + self.y_offset;
                return;
            end

            if mod(t, 1/self.frequency) <= 0.5/self.frequency
                out = self.amplitude + self.y_offset;
            else
                out = -self.amplitude + self.y_offset;
            end
        end

        function out = sawtooth(self, t)
            if self.frequency == 0
                out = self.y_offset;
                return;
            end

            T = 1/self.frequency;
            tau = mod(t, T);
            out = (2*self.amplitude/T)*tau - self.amplitude + self.y_offset;
        end

        function out = step(self, t)
            if t >= 0.0
                out = self.amplitude + self.y_offset;
            else
                out = self.y_offset;
            end
        end

        function out = random(self, ~)
            out = self.amplitude*randn + self.y_offset;
        end

        function out = sin(self, t)
            out = self.amplitude*sin(2*pi*self.frequency*t) + self.y_offset;
        end
    end
end