module AMA
  module Chef
    module Cookbook
      module DockerCompose
        class PathSpec
          def self.installation(sub_path = nil)
            path = '/tmp/kitchen/installation'
            path = ::File.join(path, sub_path) if sub_path
            path
          end

          def self.deployment(sub_path = nil)
            path = '/tmp/kitchen/deployment'
            path = ::File.join(path, sub_path) if sub_path
            path
          end
        end
      end
    end
  end
end