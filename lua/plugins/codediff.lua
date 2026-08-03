return {
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    opts = {
      highlights = {
        line_insert = "#1c3a29",
        line_delete = "#4b2224",
        char_insert = "#2d6a3f",
        char_delete = "#7a2e33",
      },
      diff = {
        ignore_trim_whitespace = true,
      },
      explorer = {
        position = "left",
        initial_focus = "modified",
        focus_on_select = true,
        width = 30,
        view_mode = "tree",
      },
    },
  },
}
