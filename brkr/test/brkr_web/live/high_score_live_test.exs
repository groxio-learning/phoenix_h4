defmodule BrkrWeb.HighScoreLiveTest do
  use BrkrWeb.ConnCase

  import Phoenix.LiveViewTest
  import Brkr.ScoreboardFixtures

  @create_attrs %{initials: "some initials", start_time: "2025-07-24T16:23:00", stop_time: "2025-07-24T16:23:00"}
  @update_attrs %{initials: "some updated initials", start_time: "2025-07-25T16:23:00", stop_time: "2025-07-25T16:23:00"}
  @invalid_attrs %{initials: nil, start_time: nil, stop_time: nil}

  defp create_high_score(_) do
    high_score = high_score_fixture()
    %{high_score: high_score}
  end

  describe "Index" do
    setup [:create_high_score]

    test "lists all high_scores", %{conn: conn, high_score: high_score} do
      {:ok, _index_live, html} = live(conn, ~p"/high_scores")

      assert html =~ "Listing High scores"
      assert html =~ high_score.initials
    end

    test "saves new high_score", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/high_scores")

      assert index_live |> element("a", "New High score") |> render_click() =~
               "New High score"

      assert_patch(index_live, ~p"/high_scores/new")

      assert index_live
             |> form("#high_score-form", high_score: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#high_score-form", high_score: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/high_scores")

      html = render(index_live)
      assert html =~ "High score created successfully"
      assert html =~ "some initials"
    end

    test "updates high_score in listing", %{conn: conn, high_score: high_score} do
      {:ok, index_live, _html} = live(conn, ~p"/high_scores")

      assert index_live |> element("#high_scores-#{high_score.id} a", "Edit") |> render_click() =~
               "Edit High score"

      assert_patch(index_live, ~p"/high_scores/#{high_score}/edit")

      assert index_live
             |> form("#high_score-form", high_score: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#high_score-form", high_score: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/high_scores")

      html = render(index_live)
      assert html =~ "High score updated successfully"
      assert html =~ "some updated initials"
    end

    test "deletes high_score in listing", %{conn: conn, high_score: high_score} do
      {:ok, index_live, _html} = live(conn, ~p"/high_scores")

      assert index_live |> element("#high_scores-#{high_score.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#high_scores-#{high_score.id}")
    end
  end

  describe "Show" do
    setup [:create_high_score]

    test "displays high_score", %{conn: conn, high_score: high_score} do
      {:ok, _show_live, html} = live(conn, ~p"/high_scores/#{high_score}")

      assert html =~ "Show High score"
      assert html =~ high_score.initials
    end

    test "updates high_score within modal", %{conn: conn, high_score: high_score} do
      {:ok, show_live, _html} = live(conn, ~p"/high_scores/#{high_score}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit High score"

      assert_patch(show_live, ~p"/high_scores/#{high_score}/show/edit")

      assert show_live
             |> form("#high_score-form", high_score: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#high_score-form", high_score: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/high_scores/#{high_score}")

      html = render(show_live)
      assert html =~ "High score updated successfully"
      assert html =~ "some updated initials"
    end
  end
end
