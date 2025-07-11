# DPOS Automation Toolkit

A comprehensive toolkit to automate system maintenance tasks such as driver updates, Windows updates, system inventory creation, and Windows activation. Simplify deployment and streamline your workflow with these scripts.

## Table of Contents

- [Features](#features)
- [Setup](#setup)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Scripts Overview](#scripts-overview)
- [Folder Structure](#folder-structure)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- **Driver Updates**: Automates driver installation using DISM and a pre-configured driver repository.
- **Windows Updates**: Updates installed applications and the OS via `winget` and `PSWindowsUpdate`.
- **System Inventory**: Creates a detailed hardware inventory and saves it to a network location.
- **Windows Activation**: Activates Windows using the system's original product key or third-party scripts.
- **All-in-One Execution**: Execute all tasks in sequence or selectively using a batch script.

---

## Setup

1. **Clone the Repository**:
  ```bash
  git clone https://github.com/lKiMl0213/dpos.git
  cd dpos-automation-toolkit
  ```

2. **Prepare the Environment**:
  - Open PowerShell as Administrator and set the execution policy:
    ```powershell
    Set-ExecutionPolicy RemoteSigned -Scope Process -Force
    ```
  - Install required dependencies:
    - **PSWindowsUpdate**:
     ```powershell
     Install-Module -Name PSWindowsUpdate -Force
     ```
    - **winget**: Pre-installed on most modern Windows versions.
  - **Driver Repository**: Place driver files in the `extracted` folder in the repository root.
  - **Network Configuration**: Update the network path in `inv.ps1` to match your inventory storage location:
    ```powershell
    $networkPath = "\\path\to\network"
    ```
3. **Download as ZIP**:  
  - Alternatively, click on `Code > Download ZIP`, extract the contents, and run `AioTst.bat` or `test.bat`. Refer to the [Usage](#usage) section for more details.
---

## Prerequisites

Prepare drivers using one of the following tools:

- **DriverPack Solution**: Extract drivers into a folder named `extracted` in the repository root. The `dps.ps1` script uses this folder for driver installation via DISM.
- **Snappy Driver Installer (SDI)**: Place the SDI executable in a folder named `SDI` and update the `dps.ps1` script to reflect the executable name.

Ensure the respective folders are correctly set up to avoid errors during execution.

---

## Usage

### Running the All-in-One Tool

- **AioTst.bat**:  
  Provides a menu-driven interface to execute all tasks or specific ones. Double-click to start and follow the prompts.

- **test.bat**:  
  Executes all `.ps1` scripts simultaneously. Use for testing purposes.

---

## Scripts Overview

- **AioTst.bat**: Menu-driven batch script for task execution.
- **dps.ps1**: Installs drivers using DISM from the `extracted` folder.
- **att_win.ps1**: Updates applications and the OS using `winget`.
- **att_winNEW.ps1**: Enhanced version of `att_win.ps1` with error handling.
- **winupdt.ps1**: Installs Windows updates via `PSWindowsUpdate`.
- **inv.ps1**: Generates a hardware inventory and saves it to a network location.
- **get_key.ps1**: Activates Windows using the original product key.
- **ativ_win.ps1**: Activates Windows using a third-party script.

---

## Folder Structure

```plaintext
.
├── AioTst.bat          # All-in-One batch script
├── dps.ps1             # Driver update script
├── att_win.ps1         # Windows update script
├── att_winNEW.ps1      # Enhanced Windows update script
├── winupdt.ps1         # Windows Update via PSWindowsUpdate
├── inv.ps1             # System inventory script
├── get_key.ps1         # Windows activation script
├── ativ_win.ps1        # Third-party activation script
├── extracted/          # Folder containing DriverPack Solution files
├── sdi/                # Folder containing SDI files
├── log/                # Folder for logs
└── .gitignore          # Git ignore file
```

---

## Contributing

Contributions are welcome! Fork the repository and submit a pull request with your changes.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---
