---
title: Career-Agent-Chatbot
app_file: chatbot.py
sdk: gradio
sdk_version: 5.22.0
---

# Career agent chatbot

This was my **first agentic coding project**: a tiny Gradio chat UI that calls the OpenAI API (`gpt-4o-mini`) with a fixed system prompt so the model answers as me about career, background, and skills. Context comes from plain text in `me/` (`careerprofile.txt`, `interview_c.txt`), not from retrieval. Tool definitions exist for “record email” and “record unknown question,” but the handlers are commented out, so the wiring is **very boilerplate and very crude**—good enough to learn the shape of tool calls, not production-ready.

## Status and direction

I am **not** polishing this folder as the long-term home for the idea. The plan is to **revamp it into a follow-on project** built around a **RAG pipeline** (chunked sources, embeddings, grounded answers, better eval and guardrails) instead of stuffing whole files into the system prompt.

## Running locally

1. Create a `.env` with at least `OPENAI_API_KEY` (see `python-dotenv` usage in `chatbot.py`).
2. From this directory, with dependencies installed (`requirements.txt` or the workspace `pyproject.toml` you use for agents work):

   ```bash
   python chatbot.py
   ```

3. Open the URL Gradio prints in the terminal.

For [Hugging Face Spaces](https://huggingface.co/docs/hub/spaces-sdks-gradio), the YAML frontmatter above points Spaces at `chatbot.py` and the Gradio SDK.

## Layout (short)

| Path | Role |
|------|------|
| `chatbot.py` | Gradio `ChatInterface`, OpenAI client, `Me` class, tool JSON stubs |
| `me/*.txt` | Static profile and interview notes injected into the system prompt |
| `app.py`, `src/app.py` | Alternate or experimental entrypoints (this repo grew organically) |
| `notebooks/` | Course / lab notebooks from the same learning period |

If you are browsing the portfolio for a polished product, treat this directory as a **historical milestone**, not the final architecture.
