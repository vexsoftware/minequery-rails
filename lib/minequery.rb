module Minequery
  module Methods
    def query_server(address, port, timeout = 30)
      server = Array.new

      begin
        timeout(timeout) do
          query = TCPSocket.new(address, port)
          query.puts "QUERY"

          while line = query.gets
            line_bits = line.split(" ", 2)

            case line_bits[0]
              when "SERVERPORT" then
                server.push(line_bits[1].chomp)
              when "PLAYERCOUNT" then
                server.push(line_bits[1].chomp)
              when "PLAYERLIST" then
                server.push(line_bits[1].chomp[1..-2].split(", "))
            end
          end

          query.close
        end
      rescue Exception
        server = nil
      end

      server
    end
  end
end