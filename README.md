<!-- Award -->
<div align="center">
  <a href="https://supabase.com/blog/lw12-hackathon-winners#most-technically-impressive" target="_blank">
    <img src='https://vdbs.vercel.app/medal.png' width="20%" alt="Medal image" />
  </a>
  <a href="https://supabase.com/blog/lw12-hackathon-winners#most-technically-impressive">
    <p> Most technically impressive Supabase Hackathon 2024</p>
  </a>
</div>

<!-- Supagen Demo -->
![Supagen Demo](/assets/supagen_demo.gif)

## Introduction
A CLI tool to automate manual effort/repetitive things when using Supabase.

## Architecture

This project uses [C4 Model](https://c4model.com/) to describe the architecture of the system.
![Context Diagram](/assets/c4/context.svg)

<details>
  <summary>Container Diagram</summary>

  ![Container Diagram](/assets/c4/container.svg)
</details>

<details>
  <summary>Component Diagram</summary>

  ![Component Supagen CLI Diagram](/assets/c4/component_supagen_cli.svg)
  ![Component Supagen Bricks Diagram](/assets/c4/component_supagen_bricks.svg)
</details>

## Key Objectives
- Automate manual effort/repetitive things
- Make your life easier when using supabase

## Features

- Init supabase client project using selected template
- Generate and update models and CRUD functionality based on supabase tables
- Ability to detect changes and print diff (Soon)
- Ability to install module into existing project (ex: auth, realtime, etc) (Soon)

## Getting Started

### Pre-requisites
- Dart (version 3.5.2 or higher)
- Supabase acccount and project setup

### Installation

### Linux & MacOS
```bash
curl -fsSL https://raw.githubusercontent.com/supagen/supagen/refs/heads/main/scripts/install.sh | bash
```

### Windows
1. Open PowerShell as an administrator.
2. Go to the folder you want to install the script.
3. Download the installation script:
```bash
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/supagen/supagen/refs/heads/main/scripts/install.ps1" -OutFile "install.ps1"
```
4. Run the Script
```bash
.\install.ps1
```

### Usage
```
Usage: supagen <command> [arguments]

Global options:
-h, --help    Print this usage information.
--verbose     Print verbose output.

Available commands:
  init      Initialize a new Supabase project
  update    Update Supabase table definitions
  version   Print the current version of supagen

Run "supagen help <command>" for more information about a command.
```

## Contributors
<a href="https://github.com/supagen/supagen/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=supagen/supagen" />
</a>

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
