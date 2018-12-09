defmodule BitcoinsimWeb.PageController do
  use BitcoinsimWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
