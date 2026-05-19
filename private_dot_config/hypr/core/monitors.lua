-- Monitores
-- https://wiki.hypr.land/Configuring/Basics/Monitors
--
-- Layout: [eDP-1] — [HDMI-A-1] — [DP-2]
--          0,0       1920,0       3840,0

-- Monitor Esquerdo (Notebook Legion)
hl.monitor({
  output   = "eDP-1",
  mode     = "1920x1080@60",
  position = "0x0",
  scale    = 1.0,
})

-- Monitor do Centro (AOC 27G2G4)
hl.monitor({
  output   = "HDMI-A-1",
  mode     = "1920x1080@60",
  position = "1920x0",
  scale    = 1.0,
})

-- Monitor da Direita (Dell Alienware)
hl.monitor({
  output   = "DP-2",
  mode     = "2560x1440@60",
  position = "3840x0",
  scale    = 1.0,
})
