defmodule CreateContainerConfigTest do
  use ExUnit.Case

  test "no hostname added" do
    conf = %ExDocker.Config{generic_hostname: true} |> ExDocker.Config.create_container()
    assert is_nil(conf["Hostname"])
  end

  test "defined hostname is untouched" do
    hostname = "look-at-all-this-foo"

    conf =
      %ExDocker.Config{generic_hostname: false, hostname: hostname}
      |> ExDocker.Config.create_container()

    assert conf["Hostname"] == hostname
  end

  test "environment variable formatting" do
    conf = %ExDocker.Config{environment: %{"FOO" => "bar"}} |> ExDocker.Config.create_container()
    assert conf["Env"] == ["FOO=bar"]
  end

  test "exposed port formatting" do
    conf = %ExDocker.Config{ports: %{http: "4000:80"}} |> ExDocker.Config.create_container()
    assert conf["ExposedPorts"] == %{"4000/tcp" => %{}}
  end

  test "exposed udp port formatting" do
    conf = %ExDocker.Config{ports: %{http: "4000/udp:80"}} |> ExDocker.Config.create_container()
    assert conf["ExposedPorts"] == %{"4000/udp" => %{}}
  end

  test "volume formatting" do
    conf =
      %ExDocker.Config{volumes: %{"/opt/container" => "/data"}}
      |> ExDocker.Config.create_container()

    assert conf["Volumes"] == %{"/data" => %{}}
  end
end

defmodule StartContainerConfigTest do
  use ExUnit.Case

  test "bound port formatting" do
    conf = %ExDocker.Config{ports: %{http: "4000:80"}} |> ExDocker.Config.start_container()
    assert conf["PortBindings"] == %{"4000/tcp" => [%{"HostPort" => "80"}]}
  end

  test "bound udp port formatting" do
    conf = %ExDocker.Config{ports: %{http: "4000/udp:80"}} |> ExDocker.Config.start_container()
    assert conf["PortBindings"] == %{"4000/udp" => [%{"HostPort" => "80"}]}
  end

  test "bound volume formatting" do
    conf =
      %ExDocker.Config{volumes: %{"/opt/container" => "/data"}}
      |> ExDocker.Config.start_container()

    assert conf["Binds"] == ["/opt/container:/data"]
  end
end
