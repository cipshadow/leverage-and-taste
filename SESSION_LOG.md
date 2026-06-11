# Session log — personal_vibes

---

### 2026-06-07 — fin-advice: portfolio concentration → whole-portfolio MPT → growth tilt → metals refinement

**Goal:** Decide the ideal Stripe-stock weight, then the ideal allocation across the *whole*
portfolio, using Modern Portfolio Theory — and refine the liquid-core fund choices for growth.

**Why we progressed (the thread):** started at "how much Stripe should I hold?" → generalised
to all asset classes → then to the liquid-core funds individually → tilted for growth
(expected-return sense) → refined the metals sleeve with deep web research.

**What we built:** new tool `fin-advice/investing/portfolio-mpt/` — pure-stdlib MPT optimizer
(`optimizer.py`, no installs), editable `assumptions.json`, self-contained Chart.js
`report.html`, `results.json`, and memo `PORTFOLIO_STRATEGY_MPT_20260607.md`. Computes:
current vs max-Sharpe vs growth portfolios, per-class risk-vs-value, required-return-to-justify
a Stripe weight, a human-capital (salary) overlay, an E[r]×vol sensitivity grid, an empirical
vol check off `networth-tracker/benchmarks.csv`, a fund-level liquid-core optimisation
(floors/caps), and a £-to-move rebalance table. (GitHub PRs #6 merged, #7 open.)

**The allocation change (decisions + reasoning):**
- **Stripe 18% → ~5% of net worth.** It was 18% of value but **~39% of portfolio risk**;
  return-dominated at the user's own 9.5% view, positively correlated, and salary is already a
  ~100% Stripe bet. Pure-MPT ideal ≈ 0%; ~9% growth-max; practical ~5% via glide path
  (Equity Choice→cash done; sell PEGs at vest; trim at next tender, residency/CGT-gated).
- **Bonds 3% → 10%** (VAGF) — the one negatively-correlated diversifier, badly under-used.
- **Liquid core tilted for growth:** EM ↑ (EIMI 15→25), value ↑ (IWVL 28→35), US ↓ (XUSE
  22→12) — expected return is in cheap markets; trimming US also reduces the Stripe/salary
  US-tech overlap. E[r] 6.0→6.7%, Sharpe 0.29→0.32 (modest — the big wins were Stripe + bonds).
- **Metals: GIGB → SETM.** Deep research (5 web agents) confirmed broad miners are ~79%
  iron-ore/steel — a poor "tech needs metals" proxy. Swapped to Sprott Critical Materials
  (SETM, IE000K6PPGX7, 0.75% acc) at the 10% conviction cap; cut broad commodities CMOD 10→3%.

**Key trade-offs:**
- Max-Sharpe wanted 66% bonds (best risk-adjusted but ~5% return — too conservative for a
  32yo); used a "growth at current risk" point instead, so bonds stay ~10% as property-timeline
  ballast.
- Kept it deliberately un-over-optimised: SETM + a bit of CMOD (two roles — thematic metals
  *equity* vs low-correlation commodity *hedge*); skipped a separate uranium fund. Caveat noted
  in the memo: the metals complex has already run (SETM +44% in Q3 2025), so scale in; the only
  un-chased AI-aligned legs are lithium (inside SETM) and physical uranium (optional sliver).

**Files involved:** `fin-advice/investing/portfolio-mpt/*` (new); `fin-advice/CONTEXT.md`
(appended a dated allocation entry); `fin-advice/README.md` (entry point); `fin-advice/
investing/portfolio-mpt/PORTFOLIO_STRATEGY_MPT_20260607.md` (memo updated for SETM).

**How to continue:** re-run `cd fin-advice/investing/portfolio-mpt && python3 optimizer.py`
(stdlib only); edit `assumptions.json` to test other views. Open decisions: confirm UCITS
tickers/acc-class on IBKR before buying; whether to add the optional uranium sliver; execute
the Stripe glide-down at the next tender once the advisor confirms residency/CGT.

---

### 2026-05-30 — Claude Code setup sync: SETUP-INSTRUCTIONS.md full run

**Goal:** Re-run the full Claude Code personal machine setup from SETUP-INSTRUCTIONS.md to ensure the config is current, and update go.md + CLAUDE.md to reflect new projects.

**What we did:**
- Ran `git pull` — already up to date
- Step 1: Created `~/.claude/hooks/`, `rules/`, `commands/` directories
- Step 2: Copied `/go`, `/ho`, `/tidy`, `/cv` skills to `~/.claude/commands/`
- Step 3: Rewrote both hooks (`session-log-reader.sh`, `session-handoff-writer.sh`) with `chmod +x`
- Step 4: Rewrote `~/.claude/rules/writing-style.md`
- Step 5: Overwrote `~/.claude/settings.json` with canonical version from repo
- Step 6: Updated `~/.claude/CLAUDE.md` active projects list — added 6 new projects: `bdaymail.me`, `digitalshelf`, `him-wof`, `motif-bad-bunny`, `spain-move`, `tuneraider` (did not overwrite file; patched the list only to preserve Core Context section)
- Step 7: Rewrote Project Directory Map in `~/.claude/commands/go.md` — expanded from 5 entries to 27, with short aliases for every project
- Step 8: Added `.session-handoff.md` to `~/.gitignore_global`

**Key decisions & trade-offs:**
- Step 6 (CLAUDE.md): Instructions say "copy Section 1 verbatim" but the existing file had a Core Context section not present in PERSONAL-SETUP.md Section 1. Chose to patch the active projects list only rather than overwrite, preserving the Core Context. **Why:** Overwriting would have deleted the active projects list and repo path, which is load-bearing context for every session.
- go.md aliases: Added short aliases for all projects (e.g. `tf`, `gym`, `pg`, `spain`) rather than just folder names. **Why:** Faster to type; consistent with existing pattern (`tf`, `ll`, `ds`).

**Pending:**
- `kindle-manager/dashboard.py` has uncommitted changes (pre-existing, not from this session)
- `bdaymail.me/` and `tuneraider/` are untracked new project folders — may need initial commits

**Files involved:**
- `~/.claude/CLAUDE.md` — active projects list updated
- `~/.claude/commands/go.md` — full alias table rewritten
- `~/.claude/commands/ho.md`, `go.md`, `tidy.md`, `cv.md` — refreshed from repo
- `~/.claude/hooks/session-log-reader.sh` — refreshed
- `~/.claude/hooks/session-handoff-writer.sh` — refreshed
- `~/.claude/rules/writing-style.md` — refreshed
- `~/.claude/settings.json` — refreshed
- `~/.gitignore_global` — `.session-handoff.md` added

**How to continue:** Setup is complete and current. If starting a new project session, use `/go <project>` to switch context. To initialize `bdaymail.me` or `tuneraider` as tracked projects, cd into each and do an initial git add/commit, or just start working — the session hook will inject context automatically.

---

### 2026-05-31 — Security: file encryption tools & USB-based passcode lock

**Goal:** Create a reusable file encryption system and secure sensitive medical notes on a USB stick with a strong passcode.

**What we did:**
- Created `security/` folder with 4 OpenSSL-based encryption scripts:
  - `lock.sh`: Encrypt files with AES-256-CBC + PBKDF2 (600k iterations), prompts for passcode
  - `unlock.sh`: Decrypt and display to stdout or save to file
  - `rekey.sh`: Re-encrypt with a new passcode (decrypt → re-encrypt → verify → swap)
  - `unlock-meds.sh`: Convenience wrapper targeting USB-based notes file
- Encrypted user's medical notes (`notes ward.rtf`) with initial weak 4-digit passcode
- Discovered weak passcode security risk, rekeyed with strong passcode using `rekey.sh`
- Copied all 3 core scripts (lock.sh, unlock.sh, rekey.sh) to USB stick folder
- Created comprehensive `README.md` on USB with all commands and usage instructions
- Committed all tools to personal_vibes git repo (commit 7983f7c)

**Key decisions & trade-offs:**
- Script design: Chose OpenSSL over GPG/age for simplicity (no dependencies beyond base macOS tools). **Why:** Easier to port to USB and use portably; PBKDF2 at 600k iterations provides adequate security for personal notes.
- Passcode strength: Discovered 4-digit passcode after encryption, rekeyed immediately rather than accepting weak security. **Why:** USB stick is portable; weak passcode could be brute-forced in seconds.
- USB self-containment: Copied all scripts to USB instead of referencing personal_vibes folder. **Why:** Makes the USB truly portable; user doesn't need the repo to decrypt their notes anywhere.
- Base64 armor output: Scripts use `-a` flag to base64-encode ciphertext. **Why:** Output is text-safe, can be copy-pasted or emailed if needed.

**Pending:**
- None. Encryption setup is complete and tested.

**Files involved:**
- `security/lock.sh` — created, committed
- `security/unlock.sh` — created, committed
- `security/rekey.sh` — created, committed
- `security/unlock-meds.sh` — created, committed
- `/Volumes/NO NAME/do not delete - cipri/lock.sh` — copied to USB
- `/Volumes/NO NAME/do not delete - cipri/unlock.sh` — copied to USB
- `/Volumes/NO NAME/do not delete - cipri/rekey.sh` — copied to USB
- `/Volumes/NO NAME/do not delete - cipri/README.md` — created with full instructions
- `/Volumes/NO NAME/do not delete - cipri/notes ward.rtf.enc` — encrypted with strong passcode

**How to continue:** Encryption is complete and operational. To decrypt the notes, run `cd "/Volumes/NO NAME/do not delete - cipri" && ./unlock.sh "notes ward.rtf.enc"` and provide the new passcode. All tools and instructions are on the USB; the setup is portable and doesn't depend on the personal_vibes repo.
