# ns2-patched
This is a **patched fork of NS-2.35** (the last official release of the NS-2 network simulator).  
It is updated to work out-of-the-box on **modern Ubuntu (via WSL2)** by applying essential patches and providing an automatic install script.

---

## About NS-2
**NS-2 (Network Simulator 2)** is a discrete event simulator widely used for research in:
- TCP, routing, and multicast protocols
- Wired, wireless, and satellite networks
- Simulation of queueing, mobility, and traffic models

The official project is no longer maintained, but it remains important for reproducible research.  
This fork ensures **compatibility with WSL2/Ubuntu**.

---
## Installation (WSL2 Ubuntu)
Will also work for Ubuntu but not tested for it.

If you don't have wsl2 installed, refer [installation guide](https://www.freecodecamp.org/news/how-to-install-wsl2-windows-subsystem-for-linux-2-on-windows-10/)

## Pre Configured:

If you want the fully configured image go to [drive link](https://drive.google.com/file/d/19vyjGa7T8rUCGG96N_TKXUJF9v-2wJrL/view?usp=sharing)

You can import by:
```powershell
wsl --import Ubuntu <Install Location> .\xie_ns2_wsl.tar
```

Replace <Install Location> with your install location

**Note**: Directory must be created before

## Manual Steps:

### 1. Install Git

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install git
```

### 2. Clone the repository

```bash
cd ~
git clone https://github.com/lucid-codr/ns2-patched.git
```

### 3. Run the installer

```bash
cd ns2-patched
sudo bash pre-install.sh
```

```bash
chmod +x install
find . -type f -name "*.sh" -exec chmod +x {} \;
find . -type f -name "configure" -exec chmod +x {} \;
./install
```

This Sequence:

* Installs dependencies
* Builds NS-2.35 and NAM
* Updates the bashrc environment variables 

**Note** : If you are using the orignal ns-allineone-2.35.tar.gz from sourceforge and not this patched repo
You may use the `pre-install-orignal.sh` (ensure `ns-allinone-2.35.tar.gz` is in the home directory) which also applies the patches.

### 4. Test the installation

```bash
cd ~/ns2-patched/ns-2.35/tcl/ex/
ns simple.tcl
```
or for orignal file:
```bash
cd ~/ns-allinone-2.35/ns-2.35/tcl/ex/
ns simple.tcl
```

---


## Patches in This Fork
### **Patch 1: Force GCC 4.8 Usage**
The NS-2.35 build system defaults to the latest available GCC, which breaks compilation on modern systems.  
We hardcode the compiler to `gcc-4.8` and `g++-4.8` in the following files:
- `otcl-1.14/Makefile.in`
- `ns-2.35/Makefile.in`
- `nam-1.15/Makefile.in`
- `xgraph-12.2/Makefile.in`

Change:
```make
@CC@
@CXX@
````

to:

```make
gcc-4.8
g++-4.8
```

### **Patch 2: Fix C++ Template Errors**

Modern C++ compilers reject ambiguous calls inside templates.
File: `ns-2.35/linkstate/ls.h` (line 137)

Change:

```cpp
void eraseAll() { erase(baseMap::begin(), baseMap::end()); }
```

To:

```cpp
void eraseAll() { this->erase(baseMap::begin(), baseMap::end()); }
```

This explicitly qualifies `erase` as a member of the base class.

---

## License

This project remains under the **GNU GPL v2.0 license**.
See the `LICENSE` file for details.

---

## Credits

* Original NS-2 project: [ISI/USC NS-2](http://www.isi.edu/nsnam/ns/)
* Community contributions and mirrors (SourceForge, GitHub)
* This fork: focused on **WSL2/Ubuntu auto install + compiler fixes**.

## BONUS
Single copyable command (**Will prompt for password**):
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install git
cd ~
git clone https://github.com/lucid-codr/ns2-patched.git
cd ns2-patched
sudo bash pre-install.sh
chmod +x install
find . -type f -name "*.sh" -exec chmod +x {} \;
find . -type f -name "configure" -exec chmod +x {} \;
./install
```