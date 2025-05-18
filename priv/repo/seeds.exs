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
    summary: "An epic Lua site",
    description: "Full description of the package",
    user_id: user.id
  })

Repo.insert!(%Release{
  version: "1.0.0",
  rockspec: "<content>",
  package_id: package.id
})

Repo.insert!(%Release{
  version: "1.0.1",
  rockspec: "<content>",
  package_id: package.id
})

# ------------------------------------------------

package2 = Repo.insert!(%Package{
  name: "luarocks",
  summary: "The other epic Lua site",
  description: "Full description of the package",
  user_id: user.id,
})

Repo.insert!(%Release{
  version: "0.2.0",
  rockspec: "<content>",
  package_id: package2.id
})
