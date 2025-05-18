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

alias LuaNox.Packages.Release
alias LuaNox.Accounts.User
alias LuaNox.Repo
alias LuaNox.Packages.Package

Repo.delete_all(Release)
Repo.delete_all(Package)
Repo.delete_all(User)

Repo.insert!(%User{
  id: 1,
  email: "admin@example.com",
  provider: "github",
  username: "admin",
  aka: "admin"
})

Repo.insert!(%Package{
  id: 1,
  name: "luanox",
  summary: "An epic Lua site",
  description: "Full description of the package",
  user_id: 1
})

Repo.insert!(%Release{
  id: 1,
  version: "1.0.0",
  rockspec: "<content>",
  package_id: 1
})

Repo.insert!(%Release{
  id: 2,
  version: "1.0.1",
  rockspec: "<content>",
  package_id: 1
})

# ------------------------------------------------

Repo.insert!(%Package{
  id: 2,
  name: "luarocks",
  summary: "The other epic Lua site",
  description: "Full description of the package",
  user_id: 1
})

Repo.insert!(%Release{
  id: 3,
  version: "0.2.0",
  rockspec: "<content>",
  package_id: 2
})
