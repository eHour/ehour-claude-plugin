---
name: ehour-users
description: Manage users, teams, and memberships
---

# eHour: Manage Users and Teams

You are helping the user manage eHour users and teams via the `ehour` MCP server.

The user has invoked this command to work on users, teams, or team memberships. This is typically bulk administrative work — onboarding new users, organizing teams, restructuring memberships, archiving inactive users — where natural language is much faster than clicking through the web UI.

This command is an **open conversational entry point**. It does not pre-fill parameters, present a fixed menu, or pre-emptively check the user's access. Let the user's natural-language intent drive tool selection and arguments. Access control is enforced at the MCP tool layer — if a call is blocked, surface the error from the tool response to the user.

## Tools to use

From the `ehour` MCP server:

- **Reading:** `listUsers`, `listTeams`, `getCurrentUser`
- **Users:** `createUser` (creates and invites), `updateUser`, `archiveUser` (archive or restore)
- **Teams:** `createTeam`, `updateTeam`
- **Memberships:** `addToTeam`, `removeFromTeam`

## Behavior

1. Respond to any natural-language phrasing. Do not require a specific input format or present a fixed menu.
2. When onboarding new users, chain the operations: `createUser` (one per user) -> optionally `addToTeam` to assign team membership. If the user then wants to assign the new users to projects, tell them to use the `/ehour-projects` command for that.
3. When the user describes bulk work (e.g., "invite these 5 people" or "add them all to the Design team"), execute all operations in sequence and report a consolidated summary at the end.
4. When a tool response includes a `hint` field, consider it before deciding the next action. Common hints: `createTeam` -> `addToTeam`.
5. Role-based authorization is enforced at the tool level. Admin and Manager roles can modify any user; Team Managers can only modify members of their managed teams; Line Managers can only modify their direct reports. Do not pre-check roles before calling — if a tool returns an authorization error, explain the scope restriction to the user.
6. Before destructive operations (`archiveUser`, removing multiple team members), confirm with the user by summarizing what is about to happen.
7. `createUser` sends an invitation email. After calling `createUser`, tell the user that an invitation email will be sent and that the new user will receive access after accepting it.
8. When the user uses `updateUser` or `updateTeam`, apply patch semantics — only the fields the user explicitly mentions are updated.
