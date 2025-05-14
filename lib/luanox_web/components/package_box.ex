defmodule LuaNoxWeb.PackageBox do
  use LuaNoxWeb, :html

  attr :name, :string, required: true
  attr :description, :string, default: ""
  attr :version, :string, default: "0.1.0"

  def package(assigns) do
    ~H"""
    <button class="btn btn-tertiary btn-block w-[15rem] h-[4rem]">
      <div class="grid grid-rows-2 grid-cols-2 row-gap-5 w-full h-full">
        <h3 class="font-bold justify-self-start">
          {@name}
        </h3>
        <h3 class="justify-self-end">
          {@version}
        </h3>
        <p class="col-span-2">
          {@description}
        </p>
      </div>
    </button>
    """
  end
end
