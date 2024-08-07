{
  pkgs,
  brewextracasks,
  brewextrapackages,
  hostName,
  user,
  ...
}: {
  # here go the darwin preferences and config items
  networking.hostName = hostName;
  environment = {
    shells = with pkgs; [bash fish];
    loginShell = pkgs.fish;
    systemPackages = with pkgs; [vim tmux coreutils];
    systemPath = ["/opt/homebrew/bin"];
    pathsToLink = ["/Applications"];
  };

  # switching screens, spaces for admin users
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = false;
  services.nix-daemon.enable = true;
  users.users.${user.handle}.home = "/Users/${user.handle}";

  system.defaults = {
    #
    # `man configuration.nix` on mac is useful in seeing available options
    # `defaults read -g` on mac is useful to see current settings
    LaunchServices = {
      # quarantine downloads until approved
      LSQuarantine = true;
    };
    # login window settings
    loginwindow = {
      # disable guest account
      GuestEnabled = false;
      # show name instead of username
      SHOWFULLNAME = false;
      # Disables the ability for a user to access the console by typing “>console” for a username at the login window.
      DisableConsoleAccess = true;
    };

    # file viewer settings
    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      QuitMenuItem = true;
      _FXShowPosixPathInTitle = true;
      # Use list view in all Finder windows by default
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    # trackpad settings
    trackpad = {
      # silent clicking = 0, default = 1
      ActuationStrength = 0;
      # enable tap to click
      Clicking = true;
      Dragging = true; # tap and a half to drag
      # three finger click and drag
      TrackpadThreeFingerDrag = true;
    };

    # firewall settings
    alf = {
      # 0 = disabled 1 = enabled 2 = blocks all connections except for essential services
      globalstate = 1;
      loggingenabled = 0;
      stealthenabled = 1;
    };

    spaces.spans-displays = false; # separate spaces on each display

    # dock settings
    dock = {
      # auto show and hide dock
      autohide = true;
      # remove delay for showing dock
      autohide-delay = 0.0;
      # how fast is the dock showing animation
      autohide-time-modifier = 0.2;
      expose-animation-duration = 0.2;
      tilesize = 24;
      launchanim = false;
      static-only = true;
      showhidden = true;
      show-recents = false;
      show-process-indicators = true;
      orientation = "bottom";
      mru-spaces = false;
      # mouse in top right corner will (5) start screensaver
      wvous-tr-corner = 5;
    };

    # universalaccess = {
    # get rid of extra transparency in menu bar and elsewhere
    # reduceTransparency = false;
    # };

    NSGlobalDomain = {
      # 2 = heavy font smoothing; if text looks blurry, back this down to 1
      AppleFontSmoothing = 2;
      AppleShowAllExtensions = true;
      # Dark mode
      AppleInterfaceStyle = "Dark";
      # auto switch between light/dark mode
      AppleInterfaceStyleSwitchesAutomatically = false;
      "com.apple.sound.beep.feedback" = 1;
      "com.apple.sound.beep.volume" = 0.606531; # 50%
      "com.apple.mouse.tapBehavior" = 1; # tap to click
      "com.apple.swipescrolldirection" = true; # "natural" scrolling

      "com.apple.keyboard.fnState" = false; #defaults to multimedia keys when disabled
      "com.apple.springing.enabled" = false;
      "com.apple.trackpad.scaling" = 3.0; # fast
      "com.apple.trackpad.enableSecondaryClick" = true;
      # enable full keyboard control
      # (e.g. enable Tab in modal dialogs)
      AppleKeyboardUIMode = 3;
      AppleTemperatureUnit = "Celsius";
      AppleMeasurementUnits = "Centimeters";
      # no popup menus when holding down letters
      ApplePressAndHoldEnabled = false;
      # delay before repeating keystrokes
      InitialKeyRepeat = 14;
      # delay between repeated keystrokes upon holding a key
      KeyRepeat = 1;
      AppleShowScrollBars = "Automatic";
      NSScrollAnimationEnabled = true; # smooth scrolling
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      # no automatic smart quotes
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      NSDocumentSaveNewDocumentsToCloud = false;
      # speed up animation on open/save boxes (default:0.2)
      NSWindowResizeTime = 0.001;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
    };
    CustomSystemPreferences = {};
    CustomUserPreferences = {
      NSGlobalDomain = {
        # Add a context menu item for showing the Web Inspector in web views
        WebKitDeveloperExtras = true;
      };
      "com.apple.finder" = {
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = true;
        ShowMountedServersOnDesktop = true;
        ShowRemovableMediaOnDesktop = true;
        _FXSortFoldersFirst = true;
        # When performing a search, search the current folder by default
        FXDefaultSearchScope = "SCcf";
      };
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on network or USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.screensaver" = {
        # Require password immediately after sleep or screen saver begins
        askForPassword = 1;
        askForPasswordDelay = 1;
      };
      "com.apple.screencapture" = {
        location = "~/Pictures/Screenshots";
        type = "png";
      };
      "com.apple.Safari" = {
        # Privacy: don’t send search queries to Apple
        UniversalSearchEnabled = false;
        SuppressSearchSuggestions = true;
        # Press Tab to highlight each item on a web page
        WebKitTabToLinksPreferenceKey = true;
        ShowFullURLInSmartSearchField = true;
        # Prevent Safari from opening ‘safe’ files automatically after downloading
        AutoOpenSafeDownloads = false;
        ShowFavoritesBar = false;
        IncludeInternalDebugMenu = true;
        IncludeDevelopMenu = true;
        WebKitDeveloperExtrasEnabledPreferenceKey = true;
        WebContinuousSpellCheckingEnabled = true;
        WebAutomaticSpellingCorrectionEnabled = false;
        AutoFillFromAddressBook = false;
        AutoFillCreditCardData = false;
        AutoFillMiscellaneousForms = false;
        WarnAboutFraudulentWebsites = true;
        WebKitJavaEnabled = false;
        WebKitJavaScriptCanOpenWindowsAutomatically = false;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks" = true;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled" = false;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled" = false;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles" = false;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically" = false;
      };
      "com.apple.mail" = {
        # Disable inline attachments (just show the icons)
        DisableInlineAttachmentViewing = true;
      };
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
      };
      "com.apple.print.PrintingPrefs" = {
        # Automatically quit printer app once the print jobs complete
        "Quit When Finished" = true;
      };
      "com.apple.SoftwareUpdate" = {
        AutomaticCheckEnabled = true;
        # Check for software updates daily, not just once per week
        ScheduleFrequency = 1;
        # Download newly available updates in background
        AutomaticDownload = 1;
        # Install System data files & security updates
        CriticalUpdateInstall = 1;
      };
      "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
      # Prevent Photos from opening automatically when devices are plugged in
      "com.apple.ImageCapture".disableHotPlug = true;
      # Turn on app auto-update
      "com.apple.commerce".AutoUpdate = true;
    };
  };

  # backwards compat; don't change
  system.stateVersion = 4;

  # brew is system wide anyway
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap"; # remove everything not listed here
    };
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    # TODO may toggle?
    masApps = {
      "Amazon Prime Video" = 545519333;
      #"Xcode" = 497799835;
    };
    taps = [
      "homebrew/services"
      "koekeishiya/formulae"
      "homebrew/cask-fonts"
    ];
    brews = ["gpg" "skhd" "python" "pass" "neovim" "fzf" "ripgrep" ] ++ brewextrapackages;
    casks = ["wacom-tablet" "gimp" "inkscape" "rectangle" "firefox" "utm" "font-monaspace" "wezterm"] ++ brewextracasks;
  };
}
