require "sinatra"
require "yaml"
require "cinch"
require "json"

config = YAML.load_file("config.yml")

post "/" do
  if (params.has_key?("alert"))
    alert = JSON.parse(params["alert"])
    bot = Cinch::Bot.new do
      configure do |c|
        c.server = config["server"]
        c.nick = config["nick"]
        c.realname = config["nick"]
        c.user = config["nick"]
      end

      on :connect do
        Channel(config["channel"]).send(alert["long_description"] + " (Severity: #{alert["severity"]})")
        bot.quit
      end
    end

    bot.start
  end
end
