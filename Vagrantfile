Vagrant.configure("2") do |config|
  config.vm.box = "utm/debian11"
  # Set VM properties for UTM
  config.vm.provider "utm" do |u|
    u.name = "debian_vm"
    u.memory = "2048"   # 4GB memory
    u.cpus = 4          # 4 CPUs
    u.directory_share_mode = "virtFS"
    #u.directory_share_mode = "webDAV"  # Use webDAV for manual directory sharing
  end

  # Enable X11 apps
  config.ssh.forward_x11 = true
  config.ssh.forward_agent = true

  config.vm.provision "shell", inline: <<-SHELL
    # Update package list
    sudo apt-get update

    # Install xauth (required for X11 forwarding)
    sudo apt-get install -y xauth

    # Install a lightweight X11 test application (e.g., x11-apps includes xclock)
    sudo apt-get install -y x11-apps

    # Optional: Install other GUI tools as needed
    # sudo apt-get install -y xfce4 firefox
  SHELL

  # Provisioning all requirements using a shell script
  config.vm.provision "shell", path: "provision.sh"

  # Forward port 8080 from the VM to the host for NGINX access
  config.vm.network "forwarded_port", guest: 8080, host: 8080
end

