brew -v

if [ "$?" -eq 0 ]; then
    echo "Homebrew is already installed."
    exit 0
  else
    echo "Homebrew is not installed, installing it..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
