module Minequery
  def self.query(address, port = 25566, timeout = 30, local_host = nil)
    begin
      timeout(timeout) do
        beginning_time = Time.now

        socket = TCPSocket.new(address, port, local_host)

        end_time = Time.now

        socket.puts "QUERY"

        response = socket.read
        response = response.split("\n")

        server_port = response[0].split(" ", 2)[1].to_i
        player_count = response[1].split(" ", 2)[1].to_i
        max_players = response[2].split(" ", 2)[1].to_i
        player_list = response[3].split(" ", 2)[1].chomp[1..-2].split(", ")

        socket.close

        return { :server_port => server_port, :player_count => player_count, :max_players => max_players, :player_list => player_list, :latency => (end_time - beginning_time) * 1000 }
      end
    rescue Exception
      return nil
    end
  end

  def self.query_json(address, port = 25566, timeout = 30, local_host = nil)
    begin
      timeout(timeout) do
        beginning_time = Time.now

        socket = TCPSocket.new(address, port, local_host)

        end_time = Time.now

        socket.puts "QUERY_JSON"

        query = symbolize(ActiveSupport::JSON.decode(socket.read))
        query[:latency] = (end_time - beginning_time) * 1000

        socket.close

        return query
      end
    rescue Exception
      return nil
    end
  end

  private

  # Similar to symbolize_keys! but this underscores the keys before making them symbols.
  def self.symbolize(hash)
    hash.keys.each do |key|
      hash[(key.underscore.to_sym rescue key) || key] = hash.delete(key)
    end
    hash
  end
end