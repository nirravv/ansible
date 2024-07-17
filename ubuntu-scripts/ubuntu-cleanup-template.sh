# This script is used to cleanup ubuntu in order to create a template of ubuntu server.
# Before running this script first copy your ssh key of ansible server to your ubuntu tenmplate so it can ssh into it in the future.
#!/bin/bash

# Get the current logged-in user before switching to sudo
CURRENT_USER=$(logname)

# Function to update and upgrade the system
update_system() {
  echo "Updating and upgrading the system..."
  sudo apt-get update
  sudo apt-get upgrade -y
  sudo apt-get dist-upgrade -y
  sudo apt-get autoremove -y
  sudo apt-get clean
}

# Function to remove SSH host keys
remove_ssh_host_keys() {
  echo "Removing SSH host keys..."
  sudo rm -f /etc/ssh/ssh_host_*
}

# Function to clear the machine ID
clear_machine_id() {
  echo "Clearing machine ID..."
  sudo truncate -s 0 /etc/machine-id
  sudo rm -f /var/lib/dbus/machine-id
}

# Function to remove persistent network interface rules
remove_udev_rules() {
  echo "Removing persistent network interface rules..."
  sudo rm -f /etc/udev/rules.d/70-persistent-net.rules
}

# Function to clean temporary directories
clean_tmp_directories() {
  echo "Cleaning temporary directories..."
  sudo rm -rf /tmp/*
  sudo rm -rf /var/tmp/*
}

# Function to remove log files
remove_log_files() {
  echo "Removing log files..."
  sudo find /var/log -type f -exec rm -f {} \;
}

# Function to reset the hostname
reset_hostname() {
  echo "Resetting hostname..."
  sudo hostnamectl set-hostname localhost
  sudo sed -i 's/^127.0.1.1.*$/127.0.1.1 localhost/' /etc/hosts
}

# Function to add current user to sudoers file
add_user_to_sudoers() {
  echo "Adding $CURRENT_USER to sudoers file..."
  echo "# Allow $CURRENT_USER to run sudo commands without password" | sudo EDITOR='tee -a' visudo
  echo "$CURRENT_USER ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo
}

# Function to create a script to regenerate SSH keys on first boot
create_ssh_regeneration_script() {
  echo "Creating script to regenerate SSH keys on first boot..."
  sudo tee /etc/rc.local > /dev/null <<'EOF'
#!/bin/bash
# Regenerate SSH host keys on first boot
rm -f /etc/ssh/ssh_host_*
dpkg-reconfigure openssh-server
# Disable this script after it runs
rm -- "$0"
EOF
  sudo chmod +x /etc/rc.local
}

# Function to shut down the system
shutdown_system() {
  echo "Shutting down the system..."
  sudo shutdown -h now
}

# Main script execution
echo "Preparing the VM for cloning..."

# Update and upgrade the system
update_system

# Perform cleanup steps
remove_ssh_host_keys
clear_machine_id
remove_udev_rules
clean_tmp_directories
remove_log_files
reset_hostname
add_user_to_sudoers
create_ssh_regeneration_script

# Shutdown the system
shutdown_system

echo "VM is now prepared for cloning. It will shut down shortly."

exit 0



