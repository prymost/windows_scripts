# Windows 11 Bootstrap Script

This PowerShell my personal script which automates the initial setup of a fresh Windows 11 installation with essential applications, security settings, and optimizations. The script features an **interactive menu** that lets you choose which sections to run.

## What This Script Does

### 🎯 Interactive Menu Options
The script provides 8 different options:
1. **Run everything** (full bootstrap)
2. **Install Windows Updates only**
3. **Configure Privacy & Security only**
4. **Configure Windows Features (WSL 2) only**
5. **Install Applications only**
6. **Apply System Optimizations only**
7. **Final Configurations only**
8. **Custom selection** (choose multiple sections)

### 🔄 Windows Updates (Section 1)
- Installs the PSWindowsUpdate module
- Downloads and installs all available Windows updates
- Ensures your system is up-to-date with the latest security patches

### 🔐 Privacy & Security Settings (Section 2)
- **Disables telemetry and data collection** - Stops Microsoft from collecting usage data
- **Disables advertising ID** - Prevents personalized ads based on your activity
- **Restricts location tracking** - Blocks apps from accessing your location

### 🛠️ Windows Features (Section 3)
- **Enables WSL (Windows Subsystem for Linux)** - Allows running Linux environments
- **Enables Virtual Machine Platform** - Required for WSL 2
- **Sets WSL 2 as default version**
- **Installs Ubuntu for WSL 2** - Automatically downloads and installs Ubuntu

### 🎮 GPU Detection & Drivers (Section 3A)
- **Auto-detects your GPU vendor** (NVIDIA, AMD, Intel)
- **Installs appropriate graphics software:**
  - NVIDIA: GeForce Experience (includes drivers)
  - AMD: Radeon Software Adrenalin
  - Intel: Graphics Command Center

### 📱 Essential Applications (Section 4)
The script installs these applications via winget:

**Browsers:**
- Google Chrome
- Mozilla Firefox

**Development Tools:**
- Visual Studio Code
- Git
- Windows Terminal

**Productivity:**
- 7-Zip (file compression)
- VLC Media Player (media player)
- LibreOffice (office suite)

**Communication:**
- Discord
- Zoom

**Utilities:**
- PowerToys (Windows utilities)
- ShareX (screenshot tool)
- Google Drive
- Synology Drive Client
- Apple iCloud

**Gaming:**
- Steam

**Other Apps:**
- ExpressVPN
- Logseq (note-taking)
- Notion (productivity)

### ⚡ System Optimizations (Section 5)
- **Disables Xbox services** - Reduces background processes if you don't game

### 🎯 Final Configurations (Section 6)
- **Configures Windows Terminal** - Sets up Windows Terminal as the default terminal

## How to Use

### Prerequisites
1. **Fresh Windows 11 installation**
2. **Internet connection**
3. **Administrator privileges**

### Steps to Run
1. **Download the script** to your computer
2. **Right-click on PowerShell** and select "Run as Administrator"
3. **Navigate to the script location:**
   ```powershell
   cd "d:\Workspace\windows_setup"
   ```
4. **Run the script:**
   ```powershell
   .\bootstrap-windows11.ps1
   ```
5. **Choose from the interactive menu** what sections you want to run
6. **Follow the prompts** and wait for completion
7. **Restart your computer** when prompted

### Important Notes
- ⚠️ **Must run as Administrator** - The script requires elevated privileges
- 🕒 **Takes 15-60 minutes** - Depending on your choices and internet speed
- 🔄 **Restart required** - Some features need a reboot to activate
- 🎯 **Interactive menu** - Choose only the sections you need
- 📝 **Automatically installs winget** - If not present, the script will install it

## Post-Script Setup

After running the script and restarting, complete these manual steps:

1. **Configure Git** (if you installed it):
   ```powershell
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

2. **Set up Ubuntu for WSL** (if you enabled WSL):
   ```powershell
   # Ubuntu will be available after restart
   wsl -d Ubuntu
   ```

3. **Configure GPU software** (if installed):
   - NVIDIA: Open GeForce Experience to set up drivers
   - AMD: Open Radeon Software for driver updates
   - Intel: Open Graphics Command Center

4. **Set up Visual Studio Code extensions** (if installed)
5. **Configure your development projects**
6. **Customize Windows Terminal settings** (if installed)

## Troubleshooting

### If the script fails to run:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### If winget is not found:
- The script will automatically install App Installer
- If automatic installation fails, install "App Installer" from Microsoft Store
- Restart PowerShell and try again

### If some apps fail to install:
- Check your internet connection
- Run the script again (it will skip already installed apps)
- Install failed apps manually using: `winget install --id <app-id>`

### If WSL installation fails:
- Ensure Virtualization is enabled in BIOS
- Run: `wsl --install -d Ubuntu` manually after restart

## Customization

To modify which applications are installed:

1. Edit the `$apps` array in the script (around line 320)
2. Add or remove entries in this format:
   ```powershell
   @{Name="App Name"; Id="winget.id"}
   ```
3. Find winget IDs using: `winget search "app name"`

## Security Considerations

This script:
- ✅ Only uses official Microsoft winget repositories
- ✅ Enhances your privacy by disabling data collection
- ✅ Uses official GPU vendor software sources
- ✅ Disables unnecessary services that could be attack vectors
- ✅ Includes interactive menu to avoid unwanted changes
