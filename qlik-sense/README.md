# qlik-sense

Workspace for Qlik Sense–related material. Large `.qvf` app files are ignored by default in Git (see `.gitignore`); **only** `ncr.qvf` and `thinkmetrics.qvf` are intended to be trackable once they are back in the tree.

> Still need to add to this README,md file.  About what the DAR methodolgy, the process, the data, use the output from Gemini and ChatGPT.  Also, don't forgot about the unpackt material as well.  Also, need to add lessons learned section.

## Finding lost copies of `thinkmetrics.qvf` and `ncr.qvf`

These apps were tied to Git history elsewhere and/or were lost during failed commits involving very large binaries. **`qlik-sense` itself may not be a Git repository**, so recovery does not rely on this folder alone. We work through the following in order.

### 1. Another clone or remote

If anything was ever pushed, or another machine has a clone, that is the fastest source of truth. Note the remote URL and any backup paths to alternate working trees.

### 2. Git history on disk (other repos)

Search your user profile for Git work trees, then check whether those commits ever contained the exact paths `ncr.qvf` or `thinkmetrics.qvf` (or common variants such as `WORKINGCopyNCR` in filenames).

Typical steps:

- Find directories named `.git` under your home or project roots (bounded `find` depth is enough to avoid huge scans).
- In each repo, list history for those paths (`git log --all -- …`) or scan `--name-only` output for `ncr` / `thinkmetrics`.
- Use `safe.directory=*` (or fix ownership) if Git refuses to run in WSL-cross-mounted Windows folders.

### 3. Corrupt or partial repo: dangling objects

If a repo broke mid-commit but still has a `.git` directory, **`git fsck`** can report dangling blobs. Large blobs might be ZIP-shaped; Qlik apps are ZIP-based, so candidates can be inspected (magic bytes / unzip layout). Many dangling blobs are unrelated (e.g. Excel exports), so each candidate still has to be validated.

### 4. Filesystem and Qlik Sense locations (no Git)

If Git has nothing useful:

- Search by **exact filename**: `thinkmetrics.qvf`, `ncr.qvf` (and case variants) under `Documents`, `Downloads`, `Desktop`, and this folder.
- Check **Qlik Sense default app folders** (e.g. `Documents\Qlik\Sense\Apps` on Windows).
- Check **OneDrive** (including “Personal” if you use two roots), **Previous Versions** / shadow copies, and **Recycle Bin**.

### 5. Script logs (clues only)

Under `Documents\Qlik\Sense\Log\Script\`, log files named after an app (e.g. `thinkmetrics…log`, `__WORKINGCopyNCR…log`) prove those apps **ran** on this machine at some time. They do **not** contain the `.qvf` binary; they only help confirm names and that a search is pointed at the right environment.

### After recovery

Once the real `.qvf` files are back in this tree, the `.gitignore` exceptions for `!**/ncr.qvf` and `!**/thinkmetrics.qvf` allow them to be committed deliberately, while other `.qvf` files stay ignored so Git and remotes are not overwhelmed by huge archives.
