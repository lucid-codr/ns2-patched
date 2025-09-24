sudo apt update && sudo apt upgrade -y
sudo apt install build-essential autoconf automake libxmu-dev libx11-dev libxt-dev tcl-dev tk-dev gawk -y
echo "deb http://in.archive.ubuntu.com/ubuntu/ bionic main universe" | sudo tee /etc/apt/sources.list.d/bionic.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
sudo apt update
sudo apt install gcc-4.8 g++-4.8 -y
echo "# deb http://in.archive.ubuntu.com/ubuntu/ bionic main universe" | sudo tee /etc/apt/sources.list.d/bionic.list
cd ~

USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

# Define the base directory
NS_DIR=$USER_HOME/ns2-patched

cd $NS_DIR
bash install.sh

BASHRC=$USER_HOME/.bashrc

BLOCK="# NS-2.35 Environment Variables
export PATH=\$PATH:\$HOME/ns2-patched/bin:\$HOME/ns2-patched/tcl8.5.10/unix:\$HOME/ns2-patched/tk8.5.10/unix
export LD_LIBRARY_PATH=\$HOME/ns2-patched/otcl-1.14:\$HOME/ns2-patched/lib
export TCL_LIBRARY=\$HOME/ns2-patched/tcl8.5.10/library"

# Check if already appended
if grep -Fxq "# NS-2.35 Environment Variables" "$BASHRC"; then
    echo "NS-2.35 environment variables already exist in $BASHRC"
else
    echo -e "\n$BLOCK" >> "$BASHRC"
    echo "NS-2.35 environment variables appended to $BASHRC"
fi

source $USER_HOME/.bashrc

echo "NS-2.35 installation and patching complete."
echo "Running exmaple simulation script."