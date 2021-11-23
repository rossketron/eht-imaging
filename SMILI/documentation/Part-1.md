# Setting up the Environment

As noted in the documentation, SMILI has been tested in Pyenv using Python 3.7 environments provided by Anaconda. 
This part is somewhat broad, but I was able to get it working.

<br>
To manually set up the environment follow the instructions below. If you wish to use the dockerfile, just run the following commands:
<br><br/>

Build:
```
sudo docker build --tag [NAME] -f smili.dockerfile .
```
Run:
```
sudo docker run -it -p 8888:8888 [NAME]
```

## Relative Links
* [Pyenv Github Repository](https://github.com/pyenv/pyenv)

## Documentation

Clone the repository
```
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
```
Install Python build dependencies
```
sudo apt-get update; sudo apt-get install --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
```
Configure your shell's environment for Pyenv
```
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init --path)"' >> ~/.profile
```
Restart terminal and check if pyenv has been installed correctly by typing 'pyenv'. We can check the list using ```pyenv install --list``` or what versions are installed using ```pyenv versions```

Install anaconda package and set to global (type python afterwards to check version is 3.7.0)
```
pyenv install anaconda3-5.3.1
pyenv global anaconda3-5.3.1
```
You can type ```python --version``` to check that we have Python 3.7
