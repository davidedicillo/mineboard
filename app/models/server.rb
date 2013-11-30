class Server < ActiveRecord::Base

  has_many :stats

  def get_stats
    contents = `sshpass -p '#{password}' ssh #{user}@#{ip} tail /var/log/supervisor/primecoin.log`
    
    lines = contents.lines.select do |line|
      line.split("]")[0] == "[STATS"
    end

    lines.each do |line|
      parts = line.split(" ")
      time_str = parts[1] + " " + parts[2]
      time = Time.parse(time_str)
      primes = parts[4].to_i
      tests = parts[6].to_i
      fivechains = parts[8].to_i
      chains = parts[10].to_f

      unless stats.where(date: time).present?
        stats.create(date: time, primes: primes, tests: tests, fivechains: fivechains, chains: chains)
      end

    end
    
  end

  def self.update_all
    Server.all.each do |server|
        server.get_stats
    end
  end

end
