brew list miniconda

if [ "$?" -eq 0 ]; then
    echo "Miniconda is already installed."
    exit 0
  else
    echo "Miniconda is not installed, installing it..."
    brew install miniconda
fi