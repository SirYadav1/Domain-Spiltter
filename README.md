# Domain Splitter Tool

A simple Bash script to split large `.txt` domain files into smaller parts. Perfect for managing domain lists for DNS configurations, web scraping, etc.

## Features

- Split `.txt` domain files into smaller parts.
- Customizable number of parts and file prefix.
- Save parts to a user-defined location.
- Remembers your settings (file prefix, output path).

## Requirements

- Unix-like OS (Linux/macOS/Termux for Android).
- Bash (pre-installed).
- `split` command (pre-installed on most systems).

## Installation

**Required packages**
```bash
pkg update && pkg install coreutils
```
 **Clone the repo:**

   ```bash
   git clone https://github.com/SirYadav1/Domain-Spiltter.git
   ```
   ```bash
   cd domain-splitter
   ```
   **Make The script executable**
   ```bash 
   chmod +x spiltter.sh
   ```
   **Run the script**
   
   ```bash 
   ./spiltter.sh
   ```
  **Follow the prompts:**

Enter the .txt domain file path.

Choose the number of parts and file prefix.

Select a save location.

The file will be split and saved to the specified location.

   