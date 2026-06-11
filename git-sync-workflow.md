# Git sync workflow

## The logic

Git has two copies of your repo: one on your laptop (local) and one on GitHub (remote). They don't sync automatically — you have to explicitly push (send local → remote) and pull (bring remote → local). Claude Code web works directly on the remote (GitHub), so when it makes changes, they live there until you pull them down.

Think of it like a shared Google Doc, except you have to manually press "sync" in both directions.

---

## After working in Claude Code web (remote has new stuff)

1. Open GitHub Desktop
2. Select the repo
3. Click **Fetch origin** (top right) — checks what's new on remote
4. If it shows "Pull origin" with a number, click it — downloads the changes to your laptop

## After working locally (laptop has new stuff)

1. Open GitHub Desktop
2. Select the repo
3. On the left you'll see all changed files — review them
4. Write a short commit message at the bottom left (e.g. "update article scraper")
5. Click **Commit to master/main**
6. Click **Push origin** (top right) — uploads to GitHub

## If both sides have changes (forgot to pull before working locally)

1. Fetch origin first
2. GitHub Desktop will warn you about diverged branches
3. Click **Pull origin** — git tries to merge automatically
4. If there are conflicts (same file edited on both sides), GitHub Desktop flags them — resolve manually in your editor, then commit the merge

---

## The rule

**Always Fetch + Pull before you start working locally.** It takes 2 seconds and prevents 90% of pain.
