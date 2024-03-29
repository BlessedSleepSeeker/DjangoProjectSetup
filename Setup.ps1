<#
Created by Camille Gouneau
12/02/2022

.Synopsis
Script Setting Up a VirtualEnv, Django, a django project template and some useful features around it

.Description
Prompt User for venv path, django version and django project name
Check if python is present, if not ask you to install it
Install and Activate the Virtual Environment
Upgrade pip
Install Django at a specific version or latest by default
Check if folder has a .git directory and if yes :
    Install pre-commit
    Generate config files for pre-commit (.pre-commit-config.yaml & .flake8)
    Get template .gitignore from gitignore.io and append or create the file
Start Django Project using django-admin function
Generate requirements.txt using pip freeze

.Parameter -Verbose
Display child commands output

.Parameter -Clean
Remove generated files

.Example
Setup.ps1
See description

.Example
Setup.ps1 -Verbose
See description. Every child command (like pip install for example) will display their output

.Example
Setup.ps1 -Clean
Delete generated files
#>


Param(
    [switch] $Verbose, # display detailled informations of launched command
    [switch] $Clean # clean up files 
)

# Remove File Created By This Script
if ($Clean) {
    Write-Host "Starting to clean up..." -BackgroundColor Cyan
    Remove-Item -Path .\.flake8
    Remove-Item -Path .\.gitignore
    Remove-Item -Path .\.pre-commit-config.yaml
    Remove-Item -Path .\requirements.txt
    Remove-Item -Path .\.venv\ -Recurse -Force
    Remove-Item -Path .\.git\hooks\pre-commit
    Write-Host "Finished Cleaning up !" -BackgroundColor Green
    Exit # Make Clean Exit outside of debug
}

# Get User Variables
$VenvPath = Read-Host "Path to Virtual Environment (leave blank to use '.venv')"
if ([string]::IsNullOrWhiteSpace($VenvPath)) {
    $VenvPath = ".venv"
}

$DjangoVersion = Read-Host "Django Version (leave blank to use the latest version)"

do {
    $DjangoProjectName = Read-Host "Name of the Django Project (can't be empty)"
} while ([string]::IsNullOrWhiteSpace($DjangoProjectName))


# Check if python is installed
Write-Host "Checking if python is present..." -BackgroundColor Yellow
$PythonReturn = & { python --version } 2>&1 #redirection cause python return to stderr
if ($PythonReturn -is [System.Management.Automation.ErrorRecord]) {
    Write-Host "Python not found. Please install Python (https://www.python.org/downloads/)" -BackgroundColor Red
    Exit
    #[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    #Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.10.7/python-3.10.7-amd64.exe" -OutFile "c:/temp/python-3.10.7-amd64.exe"
    #& c:\temp\python-3.10.7-amd64.exe \quiet InstallAllUsers=0 PrependPath=1 Include_test=0
}
else {
    Write-Host "Python is already installed, proceeding..."  -BackgroundColor Green
}

# Create Virtual Env
if (Test-Path -Path $VenvPath) {
    Write-Host "There is already a folder at '$VenvPath' , using this environnement." -BackgroundColor Gray
}
else {
    Write-Host "Creating new VirtualEnv $DjangoProjectName at $VenvPath..." -BackgroundColor Cyan
    if ($Verbose) { python -m venv $VenvPath } else { python -m venv $VenvPath | Out-Null }
}

# Launching the environnement
Write-Host "Activating the environnement..." -BackgroundColor Cyan
if ($Verbose) { & $VenvPath\Scripts\Activate.ps1 -Prompt "$DjangoProjectName" } else { & $VenvPath\Scripts\Activate.ps1 -Prompt "$DjangoProjectName" | Out-Null }
Write-Host "VirtualEnv $DjangoProjectName Activated !" -BackgroundColor Green

# Upgrading pip
Write-Host "Upgrading pip..." -BackgroundColor Cyan
if ($Verbose) { python -m pip install --upgrade pip } else { python -m pip install --upgrade pip | Out-Null }

# Installing Django
if ([string]::IsNullOrWhiteSpace($DjangoVersion)) {
    Write-Host "Installing Latest version of Django..." -BackgroundColor Cyan
    if ($Verbose) { python -m pip install Django } else { python -m pip install Django | Out-Null }
}
else {
    Write-Host "Installing Django $DjangoVersion" -BackgroundColor Cyan
    if ($Verbose) { python -m pip install Django==$DjangoVersion } else { python -m pip install Django==$DjangoVersion | Out-Null }
}

# Check if folder is a git directory
Write-Host "Checking if the current folder has a .git directory..." -BackgroundColor Yellow
if (Test-Path -Path .\.git) {
    Write-Host "Git Directory Found !" -BackgroundColor Green
    # Installing pre-commit
    Write-Host "Installing pre-commit..." -BackgroundColor Cyan
    if ($Verbose) { python -m pip install pre-commit } else { python -m pip install pre-commit | Out-Null }

    # Creating config file from pre-commit and flake8
    Write-Host "Generating .pre-commit-flake8.yaml config file..." -BackgroundColor Cyan
    $contentPreCommitConfig =
    "# Provided by Camille GOUNEAU
# 12/09/2022
# My template Django pre-commit setup using black, blacken-docs, flake8 and some base hooks
# See .flake8 file for flake8 configuration !
# See https://pre-commit.com for more information
# See https://pre-commit.com/hooks.html for more hooks
repos:
  - repo: https://github.com/psf/black
    rev: 22.8.0
    hooks:
      - id: black
        args: [--extend-exclude=/migrations/]
  - repo: https://github.com/asottile/blacken-docs
    rev: v1.12.1
    hooks:
      - id: blacken-docs
  - repo: https://github.com/pycqa/flake8
    rev: 3.9.2
    hooks:
      - id: flake8
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.3.0
    hooks:
      - id: trailing-whitespace
      - id: check-yaml
      - id: check-added-large-files
"
    $UTF8Encoding = New-Object System.Text.UTF8Encoding $True
    [System.IO.File]::WriteAllLines('.pre-commit-config.yaml', $contentPreCommitConfig, $UTF8Encoding)

    Write-Host "Generating .flake8 config file..." -BackgroundColor Cyan
    $contentFlake8Config =
    "# Provided by Camille GOUNEAU
# 12/09/2022
# My template flake8 configuration file
[flake8]
max-line-length = 120
exclude =
    $DjangoProjectName/$DjangoProjectName/settings/*.py,
"
    [System.IO.File]::WriteAllLines('.flake8', $contentFlake8Config, $UTF8Encoding)

    # Installing hooks
    Write-Host "Installing hooks..." -BackgroundColor Cyan
    if ($Verbose) { pre-commit install } else { pre-commit install | Out-Null }


    # Generating .gitignore, gitignore generated by gitignore.io
    $url = "https://www.toptal.com/developers/gitignore/api/django"
    Write-Host "Fetching gitignore..." -BackgroundColor Cyan
    $gitIgnoreResponse = Invoke-WebRequest -Uri $url -UseBasicParsing
    if ($gitIgnoreResponse.StatusCode -ne 200) {
        Write-Error -ErrorAction Stop -Message "Problem getting the .gitignore file at the url 'https://www.toptal.com/developers/gitignore/api/django'"
    }
    $contentGitignore = $gitIgnoreResponse.Content

    # if .gitignore exist, append at the end
    # if not, create it
    if (Test-Path -Path .gitignore) {
        Add-Content -Path .gitignore -Value $contentGitignore
    }
    else {
        $UTF8Encoding = New-Object System.Text.UTF8Encoding $False
        [System.IO.File]::WriteAllLines('.gitignore', $contentGitignore, $UTF8Encoding)
    }
}

# Prompt for creating the Django Project

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "The executed command is 'django-admin startproject $DjangoProjectName'"
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "The Django Project creation will be skipped"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

$title = "Setup.ps1 - Django Project Creation"
$message = "Do you want to create a django project ?"
$result = $host.ui.PromptForChoice($title, $message, $options, 1)
switch ($result) {
    0 {
        Write-Host "Generating Django Project..." -BackgroundColor Cyan
        if ($Verbose) { django-admin startproject $DjangoProjectName } else { django-admin startproject $DjangoProjectName | Out-Null }
    } 1 {
        Write-Host "Skipped Django Project Generation !" -BackgroundColor Magenta
    }
}


# Freezing pip to requirements.txt
Write-Host "Generating requirements.txt..." -BackgroundColor Cyan
pip freeze > requirements.txt

# Finishing Message
Write-Host "Script finished, environment ready !" -BackgroundColor Green