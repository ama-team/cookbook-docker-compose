class Chef
  class Recipe
    def workspace(path = nil)
      workspace = node['ama-docker-compose']['integration']['workspace']
      path ? ::File.join(workspace, path) : workspace
    end

    def workspace_directory!(path)
      full_path = workspace(path)
      directory full_path do
        recursive true
      end
      full_path
    end
  end
end