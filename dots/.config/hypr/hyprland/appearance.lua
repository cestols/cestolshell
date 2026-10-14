-- hyprland/appearance.lua: base appearance: gaps, borders, decorations

-- Colors are static M3 roles for now; matugen will generate them in 0.5.

hl.config({
    general = {
        layout = "dwindle",

        gaps_in = 4,
        gaps_out = 5,
        gaps_workspaces = 50,

        border_size = 1,
        col = {
            active_border = "rgba(44464f77)", -- outlineVariant
            inactive_border = "rgba(1a1b2033)", -- surfaceContainerLow
        },
        resize_on_border = true,

        no_focus_fallback = true,
        allow_tearing = true, -- only enables the `immediate` window rule

        snap = {
            enabled = true,
            window_gap = 4,
            monitor_gap = 5,
            respect_gaps = true,
        },
    },

    decoration = {
        rounding = 18,
        rounding_power = 2.5, -- 2 = circle, higher = squircle

        blur = {
            enabled = true,
            xray = true,
            special = false,
            new_optimizations = true,
            size = 10,
            passes = 3,
            brightness = 1,
            noise = 0.05,
            contrast = 0.89,
            vibrancy = 0.5,
            vibrancy_darkness = 0.5,
            popups = false,
            input_methods = true,
            input_methods_ignorealpha = 0.8,
        },

        shadow = {
            enabled = true,
            range = 20,
            offset = { 0, 2 },
            render_power = 10,
            color = "rgba(00000020)",
        },

        dim_inactive = true,
        dim_strength = 0.05,
        dim_special = 0.2,
    },

    dwindle = {
        preserve_split = true,
        smart_split = false,
        smart_resizing = false,
    },

    misc = {
        background_color = "rgba(121318ff)", -- surface, shown until the shell draws a wallpaper
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,

        vrr = 0,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        animate_manual_resizes = false,
        animate_mouse_windowdragging = false,
        enable_swallow = false,
        on_focus_under_fullscreen = 2,
        allow_session_lock_restore = true,
        session_lock_xray = true,
        initial_workspace_tracking = false,
        focus_on_activate = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },

    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
})
