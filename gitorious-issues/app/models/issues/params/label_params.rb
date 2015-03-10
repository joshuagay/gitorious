module Issues
  module Params

    class LabelParams
      include Virtus.model

      attribute :name,  String
      attribute :color, String
    end

  end
end
