# fastfetch tranny colors
{
  programs.fastfetch = {
    enable = true;
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json";
      logo = {
        type = "auto";
        width = 65;
        height = 35;
        padding = {
          top = 0;
          left = 0;
          right = 2;
        };
        color = {
          "1" = "#5BCEFA";
          "2" = "#F5A9B8";
          "3" = "#FFFFFF";
          "4" = "#FFFFFF";
          "5" = "#F5A9B8";
          "6" = "#5BCEFA";
        };
      };
      modules = [
        "title" "separator" "os" "host" "kernel" "uptime" "packages"
        "shell" "display" "de" "wm" "wmtheme" "theme" "icons" "font"
        "cursor" "terminal" "terminalfont" "cpu" "gpu" "memory" "swap"
        "disk" "localip" "battery" "poweradapter" "locale" "break" "colors"
      ];
    };
  };
}
