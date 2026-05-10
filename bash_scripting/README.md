# Bash scripting (Handout 01)

Course walkthrough: [YouTube — Bash Scripting](https://www.youtube.com/watch?v=PNhq_4d-5ek)

PDF: `01_TWN_Bash_Scripting_Handout.01.pdf` (local handout; open it in a viewer to follow the lab steps).

## Log analysis scripts (`01_logs/`)

| File | Role |
|------|------|
| `analyze_logs.sh` | Original / handout-style script as you left it in the repo. |
| `analyze_logs_cusorized.sh` | Completed reference version that finishes the reporting flow described in the exercise. |

### Differences: `analyze_logs_cusorized.sh` vs `analyze_logs.sh`

- **`FILE_NAME`:** The original script echoes `$FILE_NAME` but never sets it, so the label in the output is wrong or empty. The cursorized script sets `FILE_NAME=$(basename "$LOG_FILE")` for each file.
- **`REPORT_FILE`:** The original defines `REPORT_FILE` but never writes to it. In the quoted assignment `REPORT_FILE="~/portfolio/..."`, tilde does not expand, so the path would be wrong even if you redirected output later. The cursorized script uses `"${HOME}/portfolio/..."`, uses `REPORT_FILE` for real output, and prints where the report was saved.
- **Reporting:** The cursorized script wraps the analysis in `{ ... } | tee "$REPORT_FILE"` so you get the same text on the terminal **and** in `log_analysis_report.txt` under `bash_scripting/`, plus a short report header with a timestamp.
- **Totals:** The cursorized script adds a **per-file subtotal** (sum of all pattern matches for that log) before the final grand total; the original only prints a grand total.
- **`grep -c` with zero matches:** GNU `grep -c` exits with status `1` when the count is zero (even though it prints `0`). The cursorized script avoids surprises with `|| true` and `COUNT=${COUNT:-0}` so the arithmetic and tests stay reliable.
- **Shebang / style:** The cursorized script uses `#!/bin/bash` and normalizes the intro line about which logs are listed; behavior matches the same `find` and pattern loop as the original.

Run the completed version:

```bash
bash ~/portfolio/bash_scripting/01_logs/analyze_logs_cusorized.sh
```

Run the original (unchanged) version:

```bash
bash ~/portfolio/bash_scripting/01_logs/analyze_logs.sh
```
