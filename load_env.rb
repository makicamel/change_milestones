require "pathname"

module LoadEnv
  def self.execute(test: true)
    file = File.read(Pathname.pwd + ".env")
    env = file.split("\n")
              .map(&:chomp)
              .reject { |line| line == "" || line.start_with?("#") }
              .map { |line| test ? line.sub("_TEST", "") : line.sub("_PRODUCTION", "") }
              .map { |line| line.split("=") }
              .select { |array| array.size == 2 }
              .to_h
    env.each { |key, value| ENV[key] = value }
  end
end
