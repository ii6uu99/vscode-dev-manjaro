# dlauncher
A simple application launcher/browser like dmenu or wofi.
This is a simple application launcher/browser, it doesn't need any additional configuration.
I created it for myself to use with sway on Debian. If someone finds it useful for his/her situation, I'd be happy :).
It was tested on Debian Testing, it might as well run on your version/distribution.

# What you can do with dlauncher
   1. Quickly search for and run any application installed on your system.
   2. Get a list of all applications.
   3. Get a list of applications sort by category.

# Screenshots
![Alt text](https://github.com/DiogenesVX/dlauncher/blob/main/dlauncher.png)

![Alt text](https://github.com/DiogenesVX/dlauncher/blob/main/dlauncher2.png)

![Alt text](https://github.com/DiogenesVX/dlauncher/blob/main/dlauncher3.png)

![Alt text](https://github.com/DiogenesVX/dlauncher/blob/main/dlauncher4.png)

# Usage
  just launch the script the way you like (either with a key combination, or with a .desktop launcher or simply ./dlauncher)
  If you want to add it to a keyboard shortcut then modify your sway config as follows (i placed dlauncher in /opt/dlauncher/):
  
      set $menu /opt/dlauncher/dlauncher | xargs swaymsg exec --
      bindsym $mod+space exec $menu ### my combination is $mod+space, you can choose any
      for_window [app_id="(?i)yad"] floating enable
  
 Make sure you have the following packages installed:
 
      sed
      yad
      grep
      gawk
      bash
      procps
      findutils
      coreutils
      fonts-noto-color-emoji
