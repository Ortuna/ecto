defmodule Ecto.Query.JoinBuilder do
  @moduledoc false

  # Escapes a join expression (not including the on expression) returning a pair
  # of `{ binds, expr }`. `binds` is either an empty list or a list of single
  # atom binding. `expr` is either an alias or an association join of format
  # `entity.field`.

  def escape({ :in, _, [{ var, _, context }, expr] }, vars)
      when is_atom(var) and is_atom(context) do
    { [var], escape(expr, vars) |> elem(1) }
  end

  def escape({ :in, _, [{ var, _, context }, expr] }, vars)
      when is_atom(var) and is_atom(context) do
    { [var], escape(expr, vars) |> elem(1) }
  end

  def escape({ :__aliases__, _, _ } = module, _vars) do
    { [], module }
  end

  def escape({ { :., _, _ } = assoc, _, [] }, vars) do
    escape(assoc, vars)
  end

  def escape({ :., _, [{ var, _, context }, field] }, vars)
      when is_atom(var) and is_atom(context) and is_atom(field) do
    left_escaped = Ecto.Query.BuilderUtil.escape_var(var, vars)
    assoc = { :{}, [], [:., [], [left_escaped, field]] }
    { [], assoc }
  end

  def escape(_other, _vars) do
    raise Ecto.InvalidQuery, reason: "invalid `join` query expression"
  end
end
