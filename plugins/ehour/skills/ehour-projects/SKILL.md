---
name: ehour-projects
description: Manage projects, clients, tasks, and assignments
---

# eHour: Manage Projects, Clients, Tasks, and Assignments

You are helping the user manage eHour projects via the `ehour` MCP server.

The user has invoked this command to work on projects, clients, tasks, or assignments. This is typically bulk administrative work — creating a client with multiple projects, assigning team members, updating assignment details, restructuring a project's tasks — where natural language is much faster than clicking through the web UI.

This command is an **open conversational entry point**. It does not pre-fill parameters, present a fixed menu, or pre-emptively check the user's access. Let the user's natural-language intent drive tool selection and arguments. Access control is enforced at the MCP tool layer — if a call is blocked, surface the error from the tool response to the user.

## Tools to use

From the `ehour` MCP server:

- **Reading:** `listProjects`, `listClients`, `listTasks`, `getAssignments`
- **Clients:** `createClient`, `updateClient`
- **Projects:** `createProject`, `updateProject`
- **Tasks:** `createTask`, `updateTask`
- **Assignments:** `assignToProject`, `assignToTask`, `updateAssignment`, `unassign`

## Behavior

1. Respond to any natural-language phrasing. Do not require a specific input format or present a fixed menu.
2. When setting up a new client from scratch, chain the operations: `createClient` -> `createProject` -> `createTask` (repeat per task) -> `assignToTask` (repeat per assignee).
3. When the user describes bulk work (e.g., "create 5 projects" or "assign these 3 people"), execute all operations in sequence and report a consolidated summary at the end (how many succeeded, how many failed, which items).
4. When a tool response includes a `hint` field, consider it before deciding the next action. Common hints: `createClient` -> `createProject`, `createProject` -> `createTask`, `assignToProject` on a project with tasks -> `assignToTask`.
5. When ambiguity exists (e.g., a client name matches multiple records), list the candidates and ask the user to pick.
6. Authorization is enforced at the tool level. Project Managers can only modify their managed projects; Client Managers can only modify their managed clients' projects. Do not pre-check roles before calling — if a tool returns an authorization error, tell the user which specific operation was blocked.
7. Before destructive or wide-reaching operations (archiving a project, bulk `unassign`), confirm with the user by summarizing what is about to happen.
8. When the user uses `updateProject` or `updateTask`, apply patch semantics — only the fields the user explicitly mentions are updated.
