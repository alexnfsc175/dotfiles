-- Workspace Rules: assignment de apps por workspace
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules

-- Produtividade / Dev
hl.window_rule({ match = { class = "^(.*Code.*)$|(.*codium.*)$|(.*VSCodium.*)$|(.*neovide.*)$" }, workspace = "2" })

-- Criação
hl.window_rule({ match = { class = "^(.*pinta.*)$|(.*krita.*)$|(.*blender.*)$|(.*Upscayl.*)$" }, workspace = "4" })

-- Áudio / Música
hl.window_rule({ match = { class = "^(.*vital.*)$|(.*fl64.*)$|(.*nicotine_plus.*)$" }, workspace = "5" })
hl.window_rule({ match = { title = "^(.*FL Studio.*)$" },                               workspace = "5" })

-- Mídia / Streaming
hl.window_rule({ match = { class = "^(.*kdenlive.*)$" },       workspace = "6" })
hl.window_rule({ match = { class = "^(.*obsproject.*)$" },      workspace = "6" })

-- Gaming
hl.window_rule({ match = { class = "^(.*steam_app.*)$|(.*gamescope.*)$|(.*atlauncher.*)$|(.*Minecraft.*)$" },                                workspace = "7" })
hl.window_rule({ match = { class = "^(.*Ryujinx.*)$|(.*cemu.*)$|(.*dolphin.*)$|(.*RetroArch.*)$|(.*xemu.*)$|(.*duckstation.*)$|(.*rpcs3.*)$" }, workspace = "7" })

-- Sistema / Virtualização
hl.window_rule({ match = { class = "^(.*virt-manager.*)$|(.*PikaBackup.*)$|(.*VirtualBox Manager.*)$" }, workspace = "8" })

-- Notas / Referência (silencioso)
hl.window_rule({ match = { class = "^(.*obsidian.*)$|(.*Zotero.*)$" }, workspace = "9 silent" })

-- Mídia / Música (silencioso)
hl.window_rule({ match = { class = "^(.*[Ss]potify.*)$|(.*tidal-hifi.*)$|(.*You[Tt]ube Music.*)$" }, workspace = "10 silent" })

-- Áudio avançado
hl.window_rule({ match = { class = "^(.*easyeffects.*)$|^(.*qpwgraph.*)$|(.*Helvum.*)$" }, workspace = "14" })

-- Game launchers (silencioso)
hl.window_rule({ match = { class = "^([Ss]team)$|(.*heroic.*)$" }, workspace = "16 silent" })

-- Sistema avançado
hl.window_rule({ match = { class = "^(.*GParted.*)$|(.*clamtk.*)$|(.*gnome.Logs.*)$" }, workspace = "17" })

-- Chat (silencioso)
hl.window_rule({ match = { class = "^(.*discord.*)$|(.*vesktop.*)$|(.*WebCord.*)$" }, workspace = "20 silent" })

-- E-mail (silencioso)
hl.window_rule({ match = { class = "^(.*thunderbird.*)$" }, workspace = "21 silent" })

-- Monitoramento (silencioso)
hl.window_rule({ match = { class = "^(.*btop.*)$" },  workspace = "22 silent" })
hl.window_rule({ match = { class = "^(.*nvtop.*)$" }, workspace = "22 silent" })
