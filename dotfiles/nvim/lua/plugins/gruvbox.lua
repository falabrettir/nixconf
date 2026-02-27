return {
  { 
    "ellisonleao/gruvbox.nvim", 
    priority = 1000, -- Ensure it loads first
    config = true, 
    opts = ... -- You can put custom options here if you want (transparent, etc.)
  },

  -- 2. Tell LazyVim to use it
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
