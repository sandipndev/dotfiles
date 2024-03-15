{
  enable = true;

  onActivation = {
    autoUpdate = true;
    upgrade = true;
  };

  brews = [
    "applesimutils"
    "docker"
    "discord"
    "mattermost"
    "zoom"
    "google-chrome"
  ];

  casks = [
    "iterm2"
    "keybase"
    "react-native-debugger"
    "visual-studio-code"
  ];

  taps = [
    "wix/brew"
  ];
}
