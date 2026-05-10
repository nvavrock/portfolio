# Bash Scripting — Project from TechWorld with Nana

This folder is my completed project from the **TechWorld with Nana** "Bash Scripting" tutorial:

- Video: [YouTube — Bash Scripting](https://www.youtube.com/watch?v=PNhq_4d-5ek)
- Handout: [`01_TWN_Bash_Scripting_Handout.01.pdf`](./01_TWN_Bash_Scripting_Handout.01.pdf)

I followed the video and the handout end-to-end, built the log-analysis script, and then used **Cursor** to take the rough handout-style script and turn it into a polished, production-quality version. The two scripts live side by side so the difference is easy to read.

## What the project covers

These topics from the handout are exercised by the scripts in [`01_logs/`](./01_logs):

| Handout section | How it shows up here |
|---|---|
| Sample Log Files | [`01_logs/application.log`](./01_logs/application.log), [`01_logs/system.log`](./01_logs/system.log) |
| Basic Linux Commands (`find`, `grep`, `grep -c`, `tail`) | Used throughout both scripts |
| Creating Your First Script (shebang, `chmod +x`, `echo -e`) | Both scripts run as standalone executables |
| Variables & Arrays (`LOG_DIR`, `ERROR_PATTERNS=(...)`) | Defined at the top of both scripts |
| Loops & Iteration (outer loop over files, inner loop over patterns) | Nested `for` loops drive the analysis |
| File Operations (`>`, `>>`, redirected reports) | The cursorized version writes a real report file |
| Conditionals (`if [ "$COUNT" -gt 0 ]; then ... fi`) | Used to print matching lines only when present |
| Best Practices (quoting `"$VAR"`, descriptive names, comments) | Cleaned up in the cursorized version |

The handout's "Real-World Impact" framing — turning 30–45 min of manual `grep`/`find` work into a one-command run — is exactly what these scripts demonstrate.

## Log analysis scripts (`01_logs/`)

| File | Role |
|------|------|
| [`analyze_logs.sh`](./01_logs/analyze_logs.sh) | Original handout-style script — what I had after working through the video. |
| [`analyze_logs_cusorized.sh`](./01_logs/analyze_logs_cusorized.sh) | "Cursorized" version — refined inside Cursor to fix bugs, add a real report file, and harden the script. |

### How Cursor improved the script

I dropped `analyze_logs.sh` into Cursor and asked it to review and complete the reporting flow. The diff between the two files is a nice demo of what Cursor catches that's easy to miss when you're learning:

- **`FILE_NAME` was never set.** The original echoes `$FILE_NAME` but never assigns it, so the labels in the output are blank. The cursorized script sets `FILE_NAME=$(basename "$LOG_FILE")` per file.
- **`REPORT_FILE` was defined but never written to.** And `REPORT_FILE="~/portfolio/..."` doesn't expand the tilde because it's inside quotes — the path would be literally `~/portfolio/...`. The cursorized version uses `"${HOME}/portfolio/..."` and actually writes to it.
- **No real reporting.** The cursorized script wraps the analysis in `{ ... } | tee "$REPORT_FILE"` so the same output goes to the terminal **and** to `log_analysis_report.txt`, with a timestamped header.
- **No per-file totals.** The original prints only a grand total. The cursorized script also prints a per-file subtotal across all patterns before the grand total.
- **`grep -c` zero-match exit status.** GNU `grep -c` exits `1` when the count is `0` (even though it prints `0`), which can break `set -e` style scripts. The cursorized script uses `|| true` and `COUNT=${COUNT:-0}` so the arithmetic and conditionals stay safe.
- **Shebang & style.** Switched `#! /bin/bash` to the conventional `#!/bin/bash`, normalized the intro line, and tightened comments.

In short: same algorithm (`find` + nested loops + `grep`), but Cursor made it *correct, observable, and safe to run in CI*.

## Run it

The completed (cursorized) version — recommended:

```bash
bash ~/portfolio/bash_scripting/01_logs/analyze_logs_cusorized.sh
```

The original handout-style version (kept unchanged for comparison):

```bash
bash ~/portfolio/bash_scripting/01_logs/analyze_logs.sh
```

After running the cursorized version, the report is also saved to:

```text
~/portfolio/bash_scripting/log_analysis_report.txt
```
