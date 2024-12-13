{ pkgs, ... }:
{
  home.packages = (with pkgs; [ pamixer ]);
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
    style = ''
      * {
      font-family: MonaspiceNE Nerd Font;
      font-weight: bold;
      font-size: 13.5px;
      min-height: 0;
      transition-property: background-color;
      transition-duration: 0.5s;
      }
      window#waybar {
        background-color: transparent;
      }
      window > box {
        border: 2px solid #206686;
        border-radius: 1px;
        background-color: rgba(1, 1, 1, 0.9);
      }
      #workspaces {
        padding-left: 0px;
        padding-right: 4px;
        border-radius: 0px;
      }
      #workspaces button {
        padding-top: 5px;
        border-radius: 0px;
        padding-bottom: 5px;
        padding-left: 6px;
        padding-right: 6px;
      }
      #workspaces button.active {
        background-color: #206686;
        color: rgb(26, 24, 38);
      }
      #workspaces button.urgent {
        color: rgb(26, 24, 38);
      }
      tooltip {
        background: rgb(48, 45, 65);
      }
      tooltip label {
        color: rgb(217, 224, 238);
      }
      #clock,
      #memory,
      #temperature,
      #cpu,
      #mpd,
      #temperature,
      #backlight,
      #pulseaudio,
      #network,
      #battery,
      #disk,
      #idle_inhibitor
      {
        padding-left: 8px;
        padding-right: 8px;
        padding-top: 0px;
        padding-bottom: 0px;
        color: rgb(181, 232, 224);
      }
      #tray {
        padding-right: 8px;
        padding-left: 13px;
      }


    '';
    settings = [
      {
        "layer" = "top";
        "position" = "bottom";
        modules-left = [
          "hyprland/workspaces"
          "battery"
          "idle_inhibitor"
        ];
        modules-center = [
          "memory"
          "clock"
          "cpu"
        ];
        modules-right = [
          "pulseaudio"
          "pulseaudio#microphone"
          "disk"
          "network"
          "tray"
        ];
        "idle_inhibitor" = {
          "format" = "{icon}";
          "format-icons" = {
            "activated" = "";
            "deactivated" = "";
          };
        };
        "disk" = {
          "path" = "/home";
          "format" = "󰋊 {percentage_used}%";
        };
        "hyprland/workspaces" = {
          "format" = "{icon}";
          "on-click" = "activate";
        };
        "pulseaudio" = {
          "scroll-step" = 5;
          "format" = "{icon} {volume}%";
          "format-muted" = "󰸈 Muted";
          "format-icons" = {
            "default" = [
              ""
              ""
              "󱄠"
            ];
          };
          "on-click" = "pamixer -t";
          "on-click-right" = "pavucontrol";
          "tooltip" = false;
        };
        "pulseaudio#microphone" = {
          "format" = "{format_source}";
          "format-source" = "󰍬 {volume}%";
          "format-source-muted" = "󰍭 Muted";
          "on-click" = "pamixer --default-source -t";
          "on-scroll-up" = "pamixer --default-source -i 5";
          "on-scroll-down" = "pamixer --default-source -d 5";
          "scroll-step" = 5;
          "on-click-right" = "pavucontrol";
        };
        "clock" = {
          "interval" = 1;
          "format" = "{:%a %F %R}";
          "tooltip" = true;
          "tooltip-format" = "<tt>{calendar}</tt>";
        };
        "memory" = {
          "interval" = 1;
          "format" = "󰨅 {percentage}%";
          "states" = {
            "warning" = 85;
          };
        };
        "cpu" = {
          "interval" = 1;
          "format" = " {usage}%";
        };
        "network" = {
          "interval" = 1;
          "format" = "  {ifname}";
          "format-alt" = "  {bandwidthUpBytes}    {bandwidthDownBytes}";
          "format-disconnected" = "󰅛 Disconnected";
          "tooltip" = false;
        };
        "temperature" = {
          "tooltip" = false;
          "thermal-zone" = 2;
          "hwmon-path" = "/sys/class/hwmon/hwmon2/temp1_input";
          "format" = " {temperatureC}°C";
        };
        "tray" = {
          "icon-size" = 12;
          "spacing" = 8;
        };
      }
    ];
  };
  programs.waybar.package = pkgs.waybar.overrideAttrs (oa: {
    mesonFlags = (oa.mesonFlags or [ ]) ++ [ "-Dexperimental=true" ];
  });
}
