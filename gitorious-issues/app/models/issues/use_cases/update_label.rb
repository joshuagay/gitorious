module Issues
  module UseCases

    class UpdateLabel
      attr_reader :params, :label

      def self.call(context)
        usecase = new(
          context.fetch(:label),
          Issues::Params::LabelParams.new(context.fetch(:params))
        )
        usecase.execute.label
      end

      def initialize(label, params)
        @label, @params = label, params
      end

      def execute
        @label.update_attributes(params.to_hash)
        self
      end
    end

  end
end
