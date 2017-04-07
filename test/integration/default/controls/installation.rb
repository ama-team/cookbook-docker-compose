# encoding: utf-8

title 'docker-compose installation profile'

profile = self
control 'default version installation' do
  describe docker_compose_installation(profile.workspace('default-version-installation/docker-compose')) do
    it { should exist }
    its('version') { should eq(profile.nested_attribute('version')) }
  end
end

control 'fixed version installation' do
  describe docker_compose_installation(profile.workspace('fixed-version-installation/docker-compose')) do
    it { should exist }
    its('version') { should eq(profile.nested_attribute('integration.fixed_version.version')) }
  end
end

control 'overwrite' do
  describe docker_compose_installation(profile.workspace('overwrite/docker-compose')) do
    it { should exist }
    its('version') { should eq(profile.nested_attribute('integration.overwrite.overwrite_version')) }
  end
end


control 'existing installation removal' do
  describe docker_compose_installation(profile.workspace('existing-installation-removal/docker-compose')) do
    it { should_not exist }
  end
end
