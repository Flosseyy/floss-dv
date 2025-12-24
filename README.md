# Mass Vehicle Cleanup

A FiveM resource that automatically deletes unoccupied vehicles on a timer with countdown warnings. Includes Discord webhook logging and manual cleanup command.

## Features

- **Automatic Cleanup**: Deletes vehicles every 30 minutes
- **Countdown Warnings**: 30 and 15 second warnings before cleanup
- **Occupied Vehicle Protection**: Skips vehicles with players inside
- **Discord Logging**: Logs every cleanup with vehicle count and initiator info
- **Manual Command**: `/massdv` to trigger cleanup manually

## Installation

1. Download and place the `floss-deletive` folder in your server's `resources` directory
2. Add `ensure floss-dv` to your `server.cfg`
3. Configure the Discord webhook URL in `server.lua`

## Configuration

Edit `server.lua` to customize:

```lua
local DISCORD_WEBHOOK = ''  -- Add your Discord webhook URL here
local CLEANUP_INTERVAL = 30 * 60 * 1000  -- 30 minutes in milliseconds
local WARNINGS = {30, 15}  -- Warning times in seconds
```

### Discord Webhook Setup

1. Go to your Discord server settings
2. Navigate to Integrations → Webhooks
3. Create a new webhook or copy an existing one
4. Paste the webhook URL into the `DISCORD_WEBHOOK` variable in `server.lua`

## Usage

### Automatic Cleanup
The resource automatically runs every 30 minutes (configurable). Players will see warnings at 30 and 15 seconds before cleanup.

### Manual Cleanup
Use the `/massdv` command to trigger an immediate cleanup with countdown warnings.

## Discord Logs

Each cleanup sends a Discord embed with:
- Number of vehicles deleted
- Who initiated the cleanup (player name + Steam ID, Console, or Automatic Timer)
- Timestamp

## Notes

- Vehicles with players inside are automatically skipped
- The resource checks all seats (driver + up to 7 passenger seats)
- Console logs show detailed cleanup information
