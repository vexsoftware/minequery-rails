module Minequery
  module Methods
    def query_server(address, port, timeout = 30)
      begin
        timeout(timeout) do
          query = TCPSocket.new(address, port)
          query.puts "QUERY"

          server_port, player_count, player_list = nil

          while line = query.gets
            line_bits = line.split(" ", 2)

            case line_bits[0]
              when "SERVERPORT" then
                server_port = line_bits[1].chomp
              when "PLAYERCOUNT" then
                player_count = line_bits[1].chomp
              when "PLAYERLIST" then
                player_list = line_bits[1].chomp[1..-2].split(", ")
            end
          end

          query.close

          return { :server_port => server_port, :player_count => player_count, :player_list => player_list }
        end
      rescue Exception
        return nil
      end
    end
  end
end