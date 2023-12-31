defmodule Rockelivery.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset
  alias Rockelivery.{Error, Order}

  @primary_key {:id, :binary_id, autogenerate: true}
  @update_params [:age, :address, :cep, :cpf, :email, :name]
  @required_params @update_params ++ [:password]
  @derive {Jason.Encoder, only: [:name, :email, :age, :address, :cep]}

  schema "users" do
    field :age, :integer
    field :address, :string
    field :cep, :string
    field :cpf, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :name, :string

    has_many :orders, Order

    timestamps()
  end

  def build(params) do
    with %Changeset{valid?: true} = changeset <- changeset(params),
         {:ok, schema} <- apply_action(changeset, :create) do
      {:ok, schema}
    else
      error -> {:error, Error.build(400, error)}
    end
  end

  def changeset(params) do
    handle_changeset(%__MODULE__{}, params, @required_params)
    |> put_password_hash()
  end

  def changeset(struct, params) do
    handle_changeset(struct, params, @update_params)
  end

  defp handle_changeset(struct, params, fields) do
    struct
    |> cast(params, fields)
    |> validate_required(fields)
    |> validate_number(:age, greater_than_or_equal_to: 18)
    |> validate_length(:cep, is: 8)
    |> validate_length(:cpf, is: 11)
    |> validate_length(:password, min: 16, max: 64)
    |> validate_length(:email, max: 320)
    |> unique_constraint([:cpf])
    |> unique_constraint([:email])
  end

  defp put_password_hash(%Changeset{valid?: true} = changeset) do
    %{changes: %{password: password}} = changeset
    password_hash = Pbkdf2.hash_pwd_salt(password)

    change(changeset, %{
      :password_hash => password_hash
    })
  end

  defp put_password_hash(changeset), do: changeset
end
