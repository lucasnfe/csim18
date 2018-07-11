return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "1.1.5",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 16,
  tilewidth = 32,
  tileheight = 32,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "lec10",
      firstgid = 1,
      filename = "lec10.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      image = "lec10.png",
      imagewidth = 256,
      imageheight = 224,
      transparentcolor = "#ff00ff",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 56,
      tiles = {
        {
          id = 0,
          properties = {
            ["h"] = 30,
            ["isPlayer"] = true,
            ["sprite"] = "map/lec10.png",
            ["w"] = 28,
            ["x"] = 2,
            ["y"] = 2
          }
        },
        {
          id = 6,
          properties = {
            ["h"] = 30,
            ["sprite"] = "map/lec10.png",
            ["w"] = 30,
            ["x"] = 2,
            ["y"] = 2
          }
        },
        {
          id = 19,
          properties = {
            ["h"] = 30,
            ["sprite"] = "map/lec10.png",
            ["w"] = 30,
            ["x"] = 2,
            ["y"] = 2
          }
        },
        {
          id = 21,
          properties = {
            ["collide"] = true
          }
        },
        {
          id = 22,
          properties = {
            ["collide"] = true
          }
        },
        {
          id = 23,
          properties = {
            ["collide"] = true
          }
        },
        {
          id = 24,
          properties = {
            ["collide"] = true
          }
        },
        {
          id = 25,
          properties = {
            ["collide"] = true
          }
        },
        {
          id = 26,
          properties = {
            ["collide"] = true
          }
        },
        {
          id = 27,
          properties = {
            ["collide"] = true
          }
        },
        {
          id = 28,
          properties = {
            ["collide"] = true
          }
        },
        {
          id = 29,
          properties = {
            ["collide"] = true
          }
        },
        {
          id = 30,
          properties = {
            ["collide"] = true
          }
        },
        {
          id = 31,
          properties = {
            ["collide"] = true
          }
        },
        {
          id = 48,
          properties = {
            ["collide"] = true
          }
        },
        {
          id = 49,
          properties = {
            ["collide"] = true
          }
        },
        {
          id = 50,
          properties = {
            ["collide"] = true
          }
        },
        {
          id = 51,
          properties = {
            ["collide"] = true
          }
        },
        {
          id = 52,
          properties = {
            ["collide"] = true
          }
        },
        {
          id = 53,
          properties = {
            ["collide"] = true
          }
        },
        {
          id = 54,
          properties = {
            ["collide"] = true
          }
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Terrain",
      x = 0,
      y = 0,
      width = 16,
      height = 16,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        26, 26, 32, 26, 26, 31, 26, 29, 29, 27, 27, 29, 26, 26, 27, 29,
        32, 39, 33, 33, 33, 33, 39, 33, 33, 33, 39, 33, 33, 33, 33, 26,
        26, 33, 35, 35, 33, 25, 33, 34, 33, 33, 33, 39, 33, 21, 33, 31,
        27, 33, 33, 33, 25, 25, 25, 33, 33, 25, 25, 33, 33, 33, 33, 29,
        31, 33, 35, 25, 25, 25, 25, 33, 35, 25, 25, 25, 25, 33, 33, 26,
        26, 33, 33, 34, 25, 25, 33, 34, 25, 25, 25, 25, 25, 33, 34, 26,
        26, 33, 35, 33, 33, 33, 35, 33, 33, 25, 25, 33, 33, 33, 33, 29,
        29, 35, 33, 25, 25, 25, 25, 33, 35, 33, 33, 33, 33, 33, 35, 32,
        26, 34, 33, 25, 25, 25, 33, 33, 34, 33, 33, 33, 25, 33, 33, 29,
        31, 33, 39, 25, 25, 25, 33, 25, 25, 33, 34, 33, 25, 35, 33, 26,
        27, 33, 33, 25, 33, 33, 33, 33, 25, 33, 33, 33, 33, 33, 33, 29,
        26, 39, 33, 33, 33, 34, 35, 33, 25, 25, 25, 33, 33, 33, 35, 26,
        32, 35, 33, 33, 25, 25, 25, 33, 33, 33, 25, 25, 25, 33, 33, 31,
        26, 33, 35, 33, 25, 25, 33, 33, 34, 35, 33, 34, 25, 33, 33, 26,
        26, 33, 33, 35, 39, 33, 39, 33, 35, 33, 33, 33, 25, 33, 33, 27,
        31, 26, 26, 29, 26, 26, 29, 26, 31, 26, 26, 26, 26, 26, 32, 26
      }
    },
    {
      type = "tilelayer",
      name = "Characters",
      x = 0,
      y = 0,
      width = 16,
      height = 16,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "Items",
      x = 0,
      y = 0,
      width = 16,
      height = 16,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    }
  }
}
