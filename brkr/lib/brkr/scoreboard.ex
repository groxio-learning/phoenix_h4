defmodule Brkr.Scoreboard do
  @moduledoc """
  The Scoreboard context.
  """

  import Ecto.Query, warn: false
  alias Brkr.Repo

  alias Brkr.Scoreboard.HighScore

  @doc """
  Returns the list of high_scores.

  ## Examples

      iex> list_high_scores()
      [%HighScore{}, ...]

  """
  def list_high_scores(limit \\ 5) do
    query = from p in HighScore, order_by: [asc: p.score_time], limit: ^limit, preload: [:user]
    Repo.all(query)
  end

  def topic, do: "scoreboard"

  @doc """
  Gets a single high_score.

  Raises `Ecto.NoResultsError` if the High score does not exist.

  ## Examples

      iex> get_high_score!(123)
      %HighScore{}

      iex> get_high_score!(456)
      ** (Ecto.NoResultsError)

  """
  def get_high_score!(id), do: Repo.get!(HighScore, id)

  @doc """
  Creates a high_score.

  ## Examples

      iex> create_high_score(%{field: value})
      {:ok, %HighScore{}}

      iex> create_high_score(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_high_score(attrs \\ %{}) do
    {:ok, high_score} =
      %HighScore{}
      |> HighScore.changeset(attrs)
      |> Repo.insert()
    Phoenix.PubSub.broadcast(Brkr.PubSub, topic(), {:high_score_created, high_score})
    high_score
  end

  def create_high_score(user, attrs) do
    {:ok, high_score} =
      %HighScore{user_id: user.id}
      |> HighScore.changeset(attrs)
      |> Repo.insert()

    Phoenix.PubSub.broadcast(Brkr.PubSub, topic(), {:high_score_created, high_score})
    high_score
  end

  @doc """
  Updates a high_score.

  ## Examples

      iex> update_high_score(high_score, %{field: new_value})
      {:ok, %HighScore{}}

      iex> update_high_score(high_score, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_high_score(%HighScore{} = high_score, attrs) do
    high_score
    |> HighScore.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a high_score.

  ## Examples

      iex> delete_high_score(high_score)
      {:ok, %HighScore{}}

      iex> delete_high_score(high_score)
      {:error, %Ecto.Changeset{}}

  """
  def delete_high_score(%HighScore{} = high_score) do
    Repo.delete(high_score)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking high_score changes.

  ## Examples

      iex> change_high_score(high_score)
      %Ecto.Changeset{data: %HighScore{}}

  """
  def change_high_score(%HighScore{} = high_score, attrs \\ %{}) do
    HighScore.changeset(high_score, attrs)
  end
end
