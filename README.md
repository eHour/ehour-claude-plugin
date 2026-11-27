# eHour for Claude Code

A Claude Code plugin that adds eHour time tracking, project management, and team administration to your AI coding assistant. Authorize once, then drive eHour through natural language.

## What you get

Three slash commands that act as open conversational entry points into the eHour MCP server:

- **`/ehour-log`** — log time, review your timesheet, control the stopwatch timer
- **`/ehour-projects`** — create and manage clients, projects, tasks, and assignments in bulk
- **`/ehour-users`** — invite users, organize teams, manage memberships in bulk

The slash commands do not pre-fill parameters or present menus. They set context for Claude and let you drive the conversation in any phrasing. Role-based access is enforced at the eHour server, not at the command level — every user sees every command, but only operations your role permits will succeed.

## Install

```
/plugin marketplace add github:eHour/ehour-claude-plugin
/plugin install ehour@ehour-plugins
```

Verify that `/ehour-log`, `/ehour-projects`, and `/ehour-users` appear in your Claude Code slash-command autocomplete (type `/` and look for them). If they don't appear immediately, restart Claude Code.

## Authentication

The first time Claude Code calls an eHour MCP tool, your browser will open to eHour's OAuth2 consent screen. Sign in, approve the requested scopes, and Claude Code will store an access token automatically. Subsequent invocations reuse the token until it expires.

If your token expires, the next tool call will trigger the OAuth2 flow again. You do not need to re-install the plugin.

## Data and privacy

The plugin holds no code of its own. It registers the eHour MCP server at `https://ehourapp.com/mcp` and adds three skills.
Claude Code sends each eHour tool call, with the data that the call needs, to that server over HTTPS.
eHour reads and writes only the data of your own eHour account, within the scopes that you approve on the consent page.
eHour handles that data as its [privacy policy](https://ehour.com/legal/privacy-policy/) describes.

## Slash command reference

| Command | Description | Domain |
|---|---|---|
| `/ehour-log` | Log time and manage your timesheet | Timesheet, stopwatch timer, assignments |
| `/ehour-projects` | Manage projects, clients, tasks, and assignments | Clients, projects, tasks, assignments |
| `/ehour-users` | Manage users, teams, and memberships | Users, teams, team memberships |

### `/ehour-log`

Entry point for time tracking. Start a conversation about logging time, checking today's entries, or controlling the stopwatch timer.

Example prompts:

- `/ehour-log what did I track today?`
- `/ehour-log log 3 hours on the API refactor`
- `/ehour-log start a timer for project X`
- `/ehour-log stop the timer and log it`

### `/ehour-projects`

Entry point for project, client, task, and assignment management. Best for bulk work like setting up a new client, assigning several people to a project, or restructuring tasks.

Example prompts:

- `/ehour-projects create client Acme with projects Website Redesign and Mobile App`
- `/ehour-projects assign Alice, Bob, and Carol to the Website Redesign project`
- `/ehour-projects list my active projects`
- `/ehour-projects rename project "Mobile App" to "iOS and Android App"`

Requires roles that grant `ehour:projects:write` scope (Admin, Manager, Project Manager, or Client Manager).

### `/ehour-users`

Entry point for user and team management. Best for onboarding, team restructuring, and bulk user operations.

Example prompts:

- `/ehour-users invite alice@example.com as a consultant`
- `/ehour-users create team "Mobile" and add Alice, Bob, Carol`
- `/ehour-users list everyone on my team`
- `/ehour-users archive inactive contractors`

Requires roles that grant `ehour:users:write` scope (Admin, Manager, Team Manager, or Line Manager).

## Troubleshooting

**The slash commands do not appear after install.** Restart Claude Code (close and reopen). Verify with `/plugin` that `ehour@ehour-plugins` is listed and enabled.

**Tool calls fail with an authorization error.** Confirm your eHour role grants the required scope (see command reference above). Your eHour administrator can adjust your roles.

**OAuth browser window does not open.** Ensure your default browser is configured and no firewall is blocking `ehourapp.com`.

**Tools return "no active assignment found".** You need at least one active project assignment in eHour before you can log time. Ask your manager or use `/ehour-projects` if you have the right role.

## License

MIT — see `LICENSE`.
