defmodule Mango.ReleaseTasks do
  @app :mango
  @repo Mango.Repo

  @start_apps [
    :postgrex,
    :ecto
  ]

  def migrate do
    IO.puts "Loading mango..."
    :ok = Application.load(@app)

    IO.puts "Starting dependencies"
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    IO.puts "Starting repos..."
    Mango.Repo.start_link(pool_size: 1)
    Ecto.Migrator.run(@repo, migrations_path(@app), :up, all: true)

    IO.puts "Success!"
    :init.stop()
  end

  def seeds do
    IO.puts "Importing seeds"
    :ok = Application.load(@app)

    IO.puts "Starting dependencies"
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    IO.puts "Starting repos..."
    Mango.Repo.start_link(pool_size: 1)

    IO.puts "Running seeds"
    Code.eval_file(get_seeds_path(@app))

    IO.puts "Success!"
    :init.stop()
  end

  defp migrations_path(app) do
    Path.join([:code.priv_dir(@app), "repo", "migrations"])
  end

  defp get_seeds_path(app) do
    Path.join([:code.priv_dir(@app), "repo", "seeds.exs"])
  end

end
