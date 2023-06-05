require "net/ssh/gateway"

class SshGatewayService
  attr_accessor :host, :port

  def initialize(host, port)
    @host = host
    @port = port
  end

  def intiat_connection
    ssh_gateway = Net::SSH::Gateway.new(
      "#{ENV["BASTION_SERVER_IP_1"]}", nil, {
        user: "#{ENV["BASTION_USER"]}",
        port: 22,
        password: "#{ENV["BASTION_PASSWORD"]}",
      }
    )
    ssh_port = ssh_gateway.open("#{host}", port)
    return ssh_gateway, ssh_port
  end
end