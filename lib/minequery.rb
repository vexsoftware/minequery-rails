module Minequery
  module Methods
    def query_server(address, port = 25566, timeout = 30)
      begin
        timeout(timeout) do
          beginning_time = Time.now

          query = TCPSocket.new(address, port)
          query.puts "QUERY"

          response = query.read
          response = response.split("\n")

          server_port = response[0].split(" ", 2)[1]
          player_count = response[1].split(" ", 2)[1]
          max_players = response[2].split(" ", 2)[1]
          player_list = response[3].split(" ", 2)[1].chomp[1..-2].split(", ")

          query.close

          end_time = Time.now

          return { :server_port => server_port, :player_count => player_count, :max_players => max_players, :player_list => player_list, :latency => (end_time - beginning_time) * 1000 }
        end
      rescue Exception
        return nil
      end
    end
  end
end