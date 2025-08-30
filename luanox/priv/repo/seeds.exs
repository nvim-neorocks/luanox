# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LuaNox.Repo.insert!(%LuaNox.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias LuaNox.RevokedKeys.RevokedKey
alias LuaNox.Packages.Release
alias LuaNox.Accounts.User
alias LuaNox.Repo
alias LuaNox.Packages.Package

Repo.delete_all(RevokedKey)
Repo.delete_all(Release)
Repo.delete_all(Package)
Repo.delete_all(User)

File.write!(
  Application.app_dir(:luanox, "priv/static/releases/luanox-1.0.0-1.rockspec"),
  "test content for luanox-1.0.0-1.rockspec"
)

File.write!(
  Application.app_dir(:luanox, "priv/static/releases/luarocks-0.2.0-1.rockspec"),
  "test content for luarocks-0.2.0-1.rockspec"
)

user =
  Repo.insert!(%User{
    email: "admin@example.com",
    provider: "github",
    username: "admin",
    aka: "admin"
  })

package =
  Repo.insert!(%Package{
    name: "luanox",
    summary:
      "A particularly long summary for the package to test line clamping in the UI. This summary is intentionally made long so that we can observe how the line clamping behaves in the user interface.",
    description: "Full description of the package",
    user_id: user.id
  })

Repo.insert!(%Release{
  version: "1.0.0",
  package_id: package.id
})

Repo.insert!(%Release{
  version: "1.0.1",
  package_id: package.id
})

# ------------------------------------------------

package2 =
  Repo.insert!(%Package{
    name: "luarocks",
    summary: "The other epic Lua site",
    description: "Full description of the package",
    user_id: user.id
  })

Repo.insert!(%Release{
  version: "0.2.0",
  package_id: package2.id
})

# ------------------------------------------------

package3 =
  Repo.insert!(%Package{
    name: "sweetie.nvim",
    summary: "Neovim colorscheme",
    description: "A clean, delightful and highly customizable Neovim colorscheme written in Lua",
    user_id: user.id
  })

Repo.insert!(%Release{
  version: "3.2.0",
  rockspec: "<content>",
  package_id: package3.id
})

# ------------------------------------------------

package4 =
  Repo.insert!(%Package{
    name: "busted",
    summary: "Elegant Lua unit testing",
    description: "Full description of the package",
    user_id: user.id
  })

Repo.insert!(%Release{
  version: "2.2.0",
  rockspec: "<content>",
  package_id: package4.id
})
