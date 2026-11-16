# Smart Report

AI-powered risk signaling and report clarity for background screening. Built for the
Accurate Hackathon 2026 (Code with Cognition).

One report, one alert: cases are ranked by a risk signal with a stated reason, every
finding shows what the candidate stated against what was verified, and every claim is
traceable to its source document and to the SLA rule that routed the decision. The
agent recommends; adjudication and adverse action stay human.

## Data statement (hackathon guidelines)

All candidate names, employers, records, documents and figures in this repository are
**fictional and self-generated** for the hackathon. No Accurate Background production,
test or development data, databases, extracts or internal datasets are used anywhere.

## What is in the repo

| Path | What it is |
| --- | --- |
| `index.html` | Static clickable prototype: queue, dashboard, report with citations, SLA panel, adjudication, candidate portal, exports. Works with no backend. |
| `agent.html` | Live agent MVP: editable fictional documents, real LLM analysis with citation gate and deterministic SLA matrix, grounded chat. Needs the API below. |
| `api/analyze.js` | Vercel serverless function: LLM extraction with verbatim citations, citation gate in code, SLA matrix in code, signal + rule ids. |
| `api/ask.js` | Vercel serverless function: report chat grounded in the findings and documents, filtered to the caller's access level before the model sees them. |

## How to run

Prototype only (no key needed): open `index.html` in a browser, or serve the folder
with any static server.

Full MVP, locally:

1. Install the Vercel CLI: `npm i -g vercel`
2. Set the key: `vercel env add ANTHROPIC_API_KEY` (an Anthropic API key; server-side only, never shipped to the browser)
3. `vercel dev`
4. Open `http://localhost:3000` for the prototype and `http://localhost:3000/agent.html` for the live agent.

Deploy: `vercel deploy --prod` from the repo root. No build step; the project is a
static page plus two serverless functions.

## How to test

- Prototype: open the queue, click the critical case (Jordan Avery), click a numbered
  citation chip to see the source passage highlighted, click `SLA 4.2` to see the rule,
  switch access level to 2 and watch criminal records lock, request candidate context,
  switch to Candidate view and answer the invitation, export PDF, Excel or ZIP.
- Live agent: on `agent.html`, press Run analysis and compare the output against the
  documents. Then edit a document and run again, for example:
  - Change the court record charge or delete the `court` document: the signal drops
    from critical and rule 4.2 leaves the list.
  - Change the application's Meridian dates to match the HR verification: the
    employment discrepancy disappears.
  - Ask the chat "why does this need review" at level 3, then at level 2: the criminal
    answer locks.
- Guardrails to verify: findings whose excerpt is not found verbatim in a document are
  dropped (the banner reports how many); the chat refuses hiring advice; the SLA
  decision comes from code, not from the model.

## Architecture

LLM extracts findings with verbatim citations from the case documents. A citation gate
in code drops any claim without a verbatim source. The SLA matrix in code decides
auto-adjudication vs recruiter review and stamps the rule id. The UI enforces access
levels L1 to L5 and keeps the candidate view to statuses only. Every analyze and ask
call emits an audit event. See the PRD for the security architecture and compliance
mapping (FCRA, EEOC individualized assessment, fair chance).

## Team

Lorena Samuel and team · Accurate Hackathon 2026.
