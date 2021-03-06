defmodule MockeryTest do
  use ExUnit.Case, async: true

  test "of/2 dev env (atom erlang mod)" do
    assert Mockery.of(:a, env: :dev) == :a
    assert Mockery.of(:a, env: :dev, by: X) == :a
    assert Mockery.of(:a, env: :dev, by: "X") == :a
  end

  test "of/2 test env (atom erlang mod)" do
    assert Mockery.of(:a) == {Mockery.Proxy, :a, nil}
    assert Mockery.of(:a, by: X) == {Mockery.Proxy, :a, X}
    assert Mockery.of(:a, by: "X") == {Mockery.Proxy, :a, X}
  end

  test "of/2 dev env (atom elixir mod)" do
    assert Mockery.of(A, env: :dev) == A
    assert Mockery.of(A, env: :dev, by: X) == A
    assert Mockery.of(A, env: :dev, by: "X") == A
  end

  test "of/2 test env (atom elixir mod)" do
    assert Mockery.of(A) == {Mockery.Proxy, A, nil}
    assert Mockery.of(A, by: X) == {Mockery.Proxy, A, X}
    assert Mockery.of(A, by: "X") == {Mockery.Proxy, A, X}
  end

  test "of/2 dev env (string elixir mod)" do
    assert Mockery.of("A", env: :dev) == A
    assert Mockery.of("A", env: :dev, by: X) == A
    assert Mockery.of("A", env: :dev, by: "X") == A
  end

  test "of/2 test env (string elixir mod)" do
    assert Mockery.of("A") == {Mockery.Proxy, A, nil}
    assert Mockery.of("A", by: X) == {Mockery.Proxy, A, X}
    assert Mockery.of("A", by: "X") == {Mockery.Proxy, A, X}
  end

  test "new/2 (atom erlang mod)" do
    assert Mockery.new(:a) == {Mockery.Proxy, :a, nil}
    assert Mockery.new(:a, by: X) == {Mockery.Proxy, :a, X}
    assert Mockery.new(:a, by: "X") == {Mockery.Proxy, :a, X}
  end

  test "new/2 (atom elixir mod)" do
    assert Mockery.new(A) == {Mockery.Proxy, A, nil}
    assert Mockery.new(A, by: X) == {Mockery.Proxy, A, X}
    assert Mockery.new(A, by: "X") == {Mockery.Proxy, A, X}
  end

  test "new/2 (string elixir mod)" do
    assert Mockery.new("A") == {Mockery.Proxy, A, nil}
    assert Mockery.new("A", by: X) == {Mockery.Proxy, A, X}
    assert Mockery.new("A", by: "X") == {Mockery.Proxy, A, X}
  end

  test "mock/3 with name (static mock)" do
    Mockery.mock(Dummy, :fun1, "value1")

    assert Process.get({Mockery, {Dummy, :fun1}}) == "value1"
  end

  test "mock/3 with name (dynamic mock)" do
    assert_raise Mockery.Error,
                 ~r/mock\(Dummy,\ \[fun1:\ 0\],\ fn\(\.\.\.\)\ \->\ \.\.\.\ end\)/,
                 fn ->
                   Mockery.mock(Dummy, :fun1, fn -> :mock end)
                 end
  end

  test "mock/3 with name and arity (static mock)" do
    Mockery.mock(Dummy, [fun1: 0], "value2")

    assert Process.get({Mockery, {Dummy, {:fun1, 0}}}) == "value2"
  end

  test "mock/3 with name and arity (dynamic mock)" do
    Mockery.mock(Dummy, [fun1: 0], fn -> :mock end)

    assert is_function(Process.get({Mockery, {Dummy, {:fun1, 0}}}))
  end

  test "mock/2 with name" do
    Mockery.mock(Dummy, :fun1)

    assert Process.get({Mockery, {Dummy, :fun1}}) == :mocked
  end

  test "mock/2 with name and arity" do
    Mockery.mock(Dummy, fun1: 0)

    assert Process.get({Mockery, {Dummy, {:fun1, 0}}}) == :mocked
  end

  test "chainable mock/2 and mock/3" do
    Dummy
    |> Mockery.mock(fun1: 0)
    |> Mockery.mock([fun2: 1], "value")

    assert Process.get({Mockery, {Dummy, {:fun1, 0}}}) == :mocked
    assert Process.get({Mockery, {Dummy, {:fun2, 1}}}) == "value"
  end
end
