# No need for shebang, it's source only

# Webhook URL, change this to your channels URL
WEBHOOK_URL="https://discord.com/api/webhooks/<CHANNEL-ID>/<TOKEN>"

# Nagios domain, used for generating our URLs (no need to set trailing slash)
NAGIOS_DOMAIN="https://monitoring.example.com/nagios"
# Nagios Name to distinguish nagios servers
NAGIOS_NAME="Nagios Europe"

# Where to log: stdout to debug
LOG_FILE="/dev/stdout"
