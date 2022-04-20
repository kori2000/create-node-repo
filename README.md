# Creating new repositories with AI
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/kori2000/telegram-bot/blob/main/LICENSE)
[![Unicorn](https://img.shields.io/badge/nyancat-approved-ff69b4.svg)](https://www.youtube.com/watch?v=QH2-TGUlwu4)

With this script generator you can create new fully automated repositories. The description of the project will be generated by keywords via an AI.

![Test Image 1](create_repo_bash.png)

## Installation

Please adjust the `template_data.yml` file before the script.

```bash
# Replace .template_data.example.yml with 
# template_data.yml to proceed

# Settings
  server_port: # server port
  git_token: # your gitub token
  git_user: # your gituser name
  git_name: # your-app-name
  git_desc: # Simple sentence, or keywords for the AI
  git_private: # true for private repo
  git_gitignore_template: # ignore templates from gitub
  git_license_template: # license template from github

```

The variable `git_desc` serves as a basis for the AI to generate a new description text

- Generating new GitHub Token: https://github.com/settings/tokens/new
- GitHub Ignore Templates: https://github.com/github/gitignore
- GitHub License Templates: https://docs.github.com/en/rest/reference/licenses

## Starting

```bash

# 🚀 Start script with
$ ./create_repo.sh

```

### AI Text Generator Example
Here is a simple example how to create an AI generated text from the `template_data.yml` file:
[![asciicast](https://asciinema.org/a/488687.svg)](https://asciinema.org/a/488687)


### Creating new Repository with NodeJS App
An illustration of how the new repository will be created:
[![asciicast](https://asciinema.org/a/488688.svg)](https://asciinema.org/a/488688)

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)