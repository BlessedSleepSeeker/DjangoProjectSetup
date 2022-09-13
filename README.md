# DjangoProjectSetup

## What is this ?

It is a Powershell Script to setup a dev environment for a Django project.

## Usage

-   Download the script and put it in your folder of choice.
-   Launch the script :  
`.\Setup.ps1`

-   You can use the `-Verbose` option to display more information about the process :  
`.\Setup.ps1 -Verbose`

-   You can use the `-Clean` option to remove the files created by the script execution :  
`.\Setup.ps1 -Clean`

-   Answer the prompts then wait for the setup and install.

## F.A.Q

### What is installed and generated ?

-   Python Virtual Env
-   pre-commit & some hooks
    -   black
    -   blacken-docs
    -   flake8
    -   trailing-whitespace
    -   check-yaml
    -   check-added-large-files
-   The config files for the hooks
-   Django
-   A Django tailored .gitignore (thanks to gitignore.io)
-   requirements.txt

### What da script doin' ? (in details)

-   Prompt User for venv path, django version and django project name
-   Check if **python** is present, if not, ask you to install it
-   Install and Activate the **Virtual Environment**
-   Upgrade **pip**
-   Install **Django** at a specific version or latest by default
-   Check if folder has a .git directory and if yes :
    -   Install **pre-commit**
    -   Generate config files for pre-commit (.pre-commit-config.yaml & .flake8)
    -   Get template .gitignore from gitignore.io and append or create the file
-   Start a new **Django Project** using django-admin function if you answer yes to the prompt
-   Generate **requirements.txt** using **pip freeze**


### Can I use/modify it ?

This script was created and tailored for my personal use mainly, but you are welcome to use, tweak and change it however you like.  
Open-Source is cool ! Do no hesitate to give me feedback or make any suggestions.
