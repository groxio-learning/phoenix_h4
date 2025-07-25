defmodule BrkrWeb.HighScoreLive.FormComponent do
  use BrkrWeb, :live_component

  alias Brkr.Scoreboard

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage high_score records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="high_score-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:initials]} type="text" label="Initials" />
        <.input field={@form[:start_time]} type="datetime-local" label="Start time" />
        <.input field={@form[:stop_time]} type="datetime-local" label="Stop time" />
        <:actions>
          <.button phx-disable-with="Saving...">Save High score</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{high_score: high_score} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Scoreboard.change_high_score(high_score))
     end)}
  end

  @impl true
  def handle_event("validate", %{"high_score" => high_score_params}, socket) do
    changeset = Scoreboard.change_high_score(socket.assigns.high_score, high_score_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"high_score" => high_score_params}, socket) do
    save_high_score(socket, socket.assigns.action, high_score_params)
  end

  defp save_high_score(socket, :edit, high_score_params) do
    case Scoreboard.update_high_score(socket.assigns.high_score, high_score_params) do
      {:ok, high_score} ->
        notify_parent({:saved, high_score})

        {:noreply,
         socket
         |> put_flash(:info, "High score updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_high_score(socket, :new, high_score_params) do
    case Scoreboard.create_high_score(socket.assigns.current_user, high_score_params) do
      {:ok, high_score} ->
        notify_parent({:saved, high_score})

        {:noreply,
         socket
         |> put_flash(:info, "High score created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
