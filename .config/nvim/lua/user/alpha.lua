local dashboard = require 'alpha.themes.dashboard'

dashboard.section.buttons = {
  type = "group",
  opts = {spacing = 3},
  val = {
    dashboard.button("SPC f d", "Telescope Find File"),
  }
}

dashboard.section.header.val = {
[[⢸⣿⣯⡳⡖⠤⣀⠀⠀⠀⠀⠀⢠⠴⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠒⠮⣝⣦⡀⠀⠀⠀⠀⠀⠀⠀]],
[[⢸⡇⡗⢌⢮⡓⢌⡳⢦⣤⣶⣾⣿⣿⣿⣿⣿⣷⣶⣶⣠⡄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠯⣢⡀⠀⠀⠀⠀⠀]],
[[⠘⡼⣠⠈⠢⡙⢆⠙⢆⢙⡿⠿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣷⣷⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠀⠀⠀⠀⠀]],
[[⠀⠱⣿⡄⠀⢱⢸⡆⠈⠋⠀⠀⠀⣠⠞⠀⠀⠉⠉⠛⠿⣿⣿⣿⣿⠿⣷⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
[[⠀⠀⣱⡽⣄⣠⡾⠁⠀⠀⠀⠀⣰⠋⠀⠀⠀⠀⠀⠀⠀⠉⠀⢀⣀⠀⠤⠄⠀⣉⣉⣒⡠⡀⠀⠀⠀⠀⠀⠀]],
[[⠀⢰⢸⣿⡆⠁⢀⠀⠀⠀⠀⢠⠁⠀⠀⠀⠀⠀⠀⠀⠀⣴⣞⣡⣴⠶⠦⠄⣲⠛⢲⣵⠟⠀⠀⠀⠀⠀⠀⠀]],
[[⠀⡧⣸⣻⣗⠔⠋⠀⠀⠀⠀⠃⠀⠀⡀⠀⠀⠀⠀⠀⢸⡟⡑⠉⠀⠀⢀⠎⣁⢀⠝⠁⠀⠀⠀⠀⠀⠀⡾⠀]],
[[⠀⠇⠩⣷⣧⡀⠀⠀⠀⡇⠀⣠⠔⠉⠀⠀⠀⠀⠀⠀⠀⠱⣧⣤⣀⠴⣗⣯⣾⠋⠀⠀⠀⠀⠀⠀⠀⣼⣃⠀]],
[[⠀⠸⡄⠑⠗⢝⣦⢄⢀⢇⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⣠⣶⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⢀⡼⠋⠀⠀]],
[[⠀⠀⣿⣄⠀⠀⠍⣿⠊⠸⣰⣦⢤⡤⢤⠤⠤⠤⠤⠖⣟⡫⠕⠋⠁⡼⢁⢞⢹⠀⠀⠀⠀⠀⢀⠾⠁⠀⠀⡄]],
[[⢀⡞⠀⠹⣷⣄⣸⣿⠂⢰⠁⠀⠉⠉⢄⠀⠀⠉⠉⠉⠀⠀⠀⣠⣾⠁⣎⣡⡞⠀⠀⠀⠀⢀⢞⣧⡴⠚⠉⠀]],
[[⢹⡱⢁⠄⡞⠻⢿⣿⠃⢸⣀⡀⠀⠀⠀⠀⠀⠀⣀⣀⣤⣶⣿⣿⣿⣿⣿⠟⠀⠀⡤⡐⠒⠊⣠⠏⠀⠀⠀⠀]],
[[⠀⠛⢽⡼⢀⡔⢁⠞⠀⠀⠻⠿⢿⣿⣿⣿⣿⣿⣿⣿⣛⣽⡿⠟⣛⠻⣃⠀⣠⠊⠈⣀⡀⠤⠃⠀⠀⠀⠀⠀]],
[[⠀⠀⢠⡵⠋⢀⡎⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣤⣿⠿⠉⠋⠁⠀⣸⠜⣡⡴⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀]],
[[⠀⠀⢻⠀⢀⠎⠀⠀⠀⠀⠀⠀⢀⡴⠞⢻⣷⡲⠋⡕⢀⠀⢀⣤⣴⠾⠟⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
[[⠀⠀⢘⣿⣾⣦⣄⠀⠀⢀⣠⣾⠿⠛⠉⠉⠉⠣⠼⣒⣣⣔⠝⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
[[⠀⠀⠘⠿⣿⣿⣿⠶⠶⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
[[⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⠤⠤⠤⠤⠤⢄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀]],
-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠊⠉⠀⠀⠀⠀⠀⠀⠀⠀⠈⠑⠢⣀⠀⠀⠀⠀⠀]],
-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⡀⠀⠀⠀]],
-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠏⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⣆⠀⠀]],
-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡇⠀⣀⠀⢠⠀⡜⠀⠀⢀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀]],
-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⠇⠀⡃⢀⠀⣴⡇⠀⣸⣿⡅⡀⠀⠀⠀⠀⡆⠀⠀⠀⣿⡇⠀]],
-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⢠⢰⡇⡎⢠⣻⣄⣠⣿⠛⣿⣿⠀⠀⠀⢠⣿⠶⡄⠀⣿⡇⠀]],
-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡇⢸⣾⣇⣿⣿⠿⣿⣿⡿⠾⢿⣿⢷⡶⢶⡾⣿⣿⣷⣿⣾⣦⠀]],
-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣷⠈⣿⣿⣿⣿⠀⣿⣿⠃⠰⣾⣿⠀⠃⠸⠀⣿⡇⢰⠄⣿⡟⠀]],
-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⢀⣿⣿⣿⣿⠀⠻⣿⠀⠰⢿⣿⡇⢰⠀⢰⣿⠇⢸⠀⣿⡇⠀]],
-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⢸⣿⣿⣿⠛⠻⡿⠿⠿⠿⠿⠿⠿⠿⠷⠾⠿⣶⣶⣶⣿⡇⠀]],
-- [[⠀⠀⠀⠀⠀⠀⠀⠀⢀⣸⣿⣾⣿⣿⣿⡄⠀⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡇⢰⠇⠀⠀⠀]],
-- [[⠀⠀⠀⠀⠀⠀⠀⣰⠋⠀⠀⠀⠈⠹⣿⣷⡀⢸⣄⡀⠀⢠⣤⠄⢀⣤⣾⣿⠀⣜⣀⣀⠀⠀]],
-- [[⠀⠀⠀⠀⠀⠀⡸⠁⠀⣀⡀⠀⠀⡀⠈⢿⣧⠀⣯⠙⠶⢦⣴⣾⣿⠿⢛⡇⢰⠃⠀⠀⠱⡀]],
-- [[⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⣿⠀⠘⣿⣆⣿⢿⣦⣼⡂⠀⣠⠞⢹⣧⡏⠀⠀⠀⠀⢃]],
-- [[⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⢿⡇⠀⢹⣿⣿⠑⠻⣏⠉⠟⠁⠀⣼⣿⣡⣿⠀⠀⠀⡟]],
-- [[⠀⠀⠀⠀⢀⡼⡃⠀⠀⠀⠀⠀⠀⢸⣿⡤⠄⣿⣿⠀⠀⠀⠀⢀⠀⠀⡟⢻⢿⡇⠀⠀⠀⡇]],
-- [[⠀⠀⠀⢀⣾⢿⣷⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⣿⣿⠀⠀⠀⠀⠸⡄⠀⢷⣾⠀⠙⢢⡀⠀⠃]],
-- [[⠀⠀⢠⣾⠏⣾⣿⠀⠀⠀⠀⠀⠀⢹⣿⠀⢀⣿⣿⠀⠀⠀⠀⠀⠈⢆⠘⣿⡆⠀⠀⠙⢴⠀]],
-- [[⠀⢀⡎⠊⣸⣿⣿⡇⠀⠀⠀⠀⠀⢸⣿⠀⣾⣿⠏⠀⠀⠀⠀⠀⠀⠈⢆⢸⡇⠀⠀⠀⠘⡇]],
-- [[⢀⠼⠇⠀⠿⠿⠿⠿⠀⠀⠀⠀⠀⠻⠿⠀⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠼⠎⠁⠀⠀⠀⠠⢷]],
}

require 'alpha'.setup({
  layout = {
    dashboard.section
  }
})
