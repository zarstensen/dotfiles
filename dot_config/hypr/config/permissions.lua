hl.config({
    ecosystem = {
        enforce_permissions = true,
        no_update_news = true,
        no_donation_nag = true,
    },
})

-- permission = /usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland, screencopy, allow
hl.permission({ binary = "/usr/(bin|local/bin)/hyprpm", type = "plugin", mode = "allow" })
hl.permission({ binary = "/usr/(bin|local/bin)/(hyprlock|grim|hyprpicker|hyprquickframe)", type = "screencopy", mode = "allow" })
