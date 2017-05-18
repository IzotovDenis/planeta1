module CarrierWave
  module MiniMagick
    def quality(percentage)
      manipulate! do |img|
        img.quality(percentage.to_s)
        img = yield(img) if block_given?
        img
      end
    end

    def strip
      manipulate! do |img|
        img.strip
        img = yield(img) if block_given?
        img
      end
    end

    def gaussian_blur(radius)
      manipulate! do |img|
        img.gaussian_blur(radius.to_s)
        img = yield(img) if block_given?
        img
      end
    end
  end
end