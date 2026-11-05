# Degrade instead of failing fast on invalid config

Status: accepted

## Context

Fail-fast is right for servers, but a shell that refuses to start leaves the user without a desktop.

## Decision

Invalid or unknown setting values fall back to their schema default. Each problem is logged as `settings.invalid` with the key and value, and shown once as an info bar in Settings and a notification. Unreadable files are treated as empty and never overwritten until the user saves.

## Consequences

The shell always starts. Users see exactly which key was ignored.
