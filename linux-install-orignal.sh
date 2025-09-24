# This is the script to patch the orignal ns-allinone-2.35 from sourceforge
# It is assumed that the ns-allinone-2.35.tar.gz is in the home directory

sudo apt update && sudo apt upgrade -y
sudo apt install build-essential autoconf automake libxmu-dev libx11-dev libxt-dev tcl-dev tk-dev gawk -y
echo "deb http://in.archive.ubuntu.com/ubuntu/ bionic main universe" | sudo tee /etc/apt/sources.list.d/bionic.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
sudo apt update
sudo apt install gcc-4.8 g++-4.8 -y
echo "# deb http://in.archive.ubuntu.com/ubuntu/ bionic main universe" | sudo tee /etc/apt/sources.list.d/bionic.list
cd ~
tar -zxvf ns-allinone-2.35.tar.gz

USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

# Define the base directory
NS_DIR=$USER_HOME/ns-allinone-2.35


if [ -d "$NS_DIR" ]; then
    echo "Directory exists: $NS_DIR"
else
    echo "Directory not found: $NS_DIR"
    exit 1
fi

# List of files to be patched
FILES=(
    "$NS_DIR/otcl-1.14/Makefile.in"
    "$NS_DIR/ns-2.35/Makefile.in"
    "$NS_DIR/nam-1.15/Makefile.in"
    "$NS_DIR/xgraph-12.2/Makefile.in"
)

# Loop through each file and apply the changes
for file in "${FILES[@]}"; do
    echo "Patching $file..."
    # Check if the file exists before trying to patch it
    if [ -f "$file" ]; then
        # Replace @CC@ with gcc-4.8
        sed -i 's/@CC@/gcc-4.8/g' "$file"
        # Replace @CXX@ with g++-4.8
        sed -i 's/@CXX@/g++-4.8/g' "$file"
    else
        echo "Warning: File not found at $file"
    fi
done

echo "Patching complete."

# File path
FILE=$USER_HOME/ns-allinone-2.35/ns-2.35/linkstate/ls.h

# Backup original file
cp "$FILE" "${FILE}.bak"

# Replace line 137 with the fixed version
sed -i '137s|void eraseAll() { erase(baseMap::begin(), baseMap::end()); }|void eraseAll() { this->erase(baseMap::begin(), baseMap::end()); }|' "$FILE"

echo "Patch applied. Backup saved as ${FILE}.bak"

cd $NS_DIRNS_DIR
sudo bash install.sh

BASHRC=$USER_HOME/.bashrc

BLOCK="# NS-2.35 Environment Variables
export PATH=\$PATH:\$HOME/ns-allinone-2.35/bin:\$HOME/ns-allinone-2.35/tcl8.5.10/unix:\$HOME/ns-allinone-2.35/tk8.5.10/unix
export LD_LIBRARY_PATH=\$HOME/ns-allinone-2.35/otcl-1.14:\$HOME/ns-allinone-2.35/lib
export TCL_LIBRARY=\$HOME/ns-allinone-2.35/tcl8.5.10/library"

# Check if already appended
if grep -Fxq "# NS-2.35 Environment Variables" "$BASHRC"; then
    echo "NS-2.35 environment variables already exist in $BASHRC"
else
    echo -e "\n$BLOCK" >> "$BASHRC"
    echo "NS-2.35 environment variables appended to $BASHRC"
fi

source ~/.bashrc

echo "NS-2.35 installation and patching complete."
echo "Running exmaple simulation script."