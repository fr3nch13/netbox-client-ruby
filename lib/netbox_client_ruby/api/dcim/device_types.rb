# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class DeviceTypes
      include Entities

      path 'dcim/device-types/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        DeviceType.new raw_entity['id']
      end
    end
  end
end
