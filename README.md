# DjangoProjectGenerator

## Usage

-   Download the script and put it in your folder of choice.
-   Launch the script :

`.\SetupEnvAndGenerateProj.ps1`

-   You can use the `-Verbose` option to display more information about the process :

`.\SetupEnvAndGenerateProj.ps1 -Verbose`

-   Answer the prompts then wait for the setup and install

## FAQ

### What da script doin' ?

-   Prompt User for venv path, django version and django project name
-   Check if python is present, if not, ask you to install it
-   Install and Activate the Virtual Environment
-   Upgrade pip
-   Install Django at a specific version or latest by default
-   Check if folder has a .git directory and if yes :
    -   Install pre-commit
    -   Generate config files for pre-commit (.pre-commit-config.yaml & .flake8)
    -   Get template .gitignore from gitignore.io and append or create the file
-   Start Django Project using django-admin function
-   Generate requirements.txt using pip freeze

### Can I use/modify it ?

This script was created for my personal use first but you are welcome to use, tweak and change it however you like.  Open-Source is cool ! Do no hesitate to give me feedback.
