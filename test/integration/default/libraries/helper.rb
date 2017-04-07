module AMA
  module Inspec
    module DockerCompose
      module DSLHelper
        def workspace(path = nil)
          ws = nested_attribute('integration.workspace')
          path ? ::File.join(ws, path) : ws
        end

        def nested_attribute(path)
          chunks = path.split('.')
          bag = attribute('ama-docker-compose', default: {})
          cursor = bag
          chunks.each do |chunk|
            next unless cursor
            unless cursor.respond_to?(:has_key?) and cursor.has_key?(chunk)
              cursor = nil
              next
            end
            cursor = cursor[chunk]
          end
          cursor
        end
      end
    end
  end
end

::Inspec::DSL.include(AMA::Inspec::DockerCompose::DSLHelper)