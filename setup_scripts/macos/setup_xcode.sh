xcode-select -v
if [ "$?" -ne 0 ]; then
  echo "Xcode Command Line Tools not installed. Installing..."
  xcode-select --install
  echo "Xcode Command Line Tools installed."
else
  echo "Xcode Command Line Tools already installed."
fi