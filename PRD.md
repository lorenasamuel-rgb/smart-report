# Accurate Signal — Product Requirements

Status: hackathon MVP, v0.2.0 · Accurate Hackathon 2026 (Code with Cognition)
Audience: product, engineering, and reviewers of the security and compliance design.

## 1. Summary

Accurate Signal ranks a background-screening case with one risk signal and a stated reason. Every finding shows what the candidate stated against what was verified, and every claim is traceable to a source document and to the SLA rule that routed the decision.

The agent recommends. Adjudication and adverse action stay human.

## 2. Problem

A screening report is a pile of verifications. The recruiter has to notice the discrepancy, find the source passage, and remember which client rule turns that discrepancy into a review. Two failures follow:

- A claim with no source gets treated as a fact.
- A model, or a rushed reader, makes the hiring call.

Accurate Signal separates those jobs. A model extracts. Code decides whether a claim is allowed to exist and which SLA rule applies. A person adjudicates.

## 3. Users

| User | What they need | What they must not get |
| --- | --- | --- |
| Recruiter | A ranked queue, one signal with a reason, cited findings, the SLA rule that fired, and a place to record a human decision. | A hire, reject, or adverse-action recommendation. |
| Candidate | Status of their own case, and a way to answer an invitation for context on a flagged finding. | Other people's cases, or the internal narrative of a criminal or credit finding. |
| Operator of the pipeline | A deterministic path from documents to signal, with an audit event on every analyze and ask call. | A decision path that lives only inside the model. |

Access is tiered L1–L5 (section 7). The prototype switches role and level in the UI so the tiers can be demonstrated. Production would bind both to the authenticated caller.

## 4. Principles

1. One report, one alert. The queue is ordered by signal. The reason is a sentence, not a score without words.
2. Stated against verified. A discrepancy finding carries both sides.
3. No source, no claim. A finding of kind match, discrepancy, or record is dropped unless at least one citation is a verbatim excerpt of the named document.
4. The model does not adjudicate. Citation gate, SLA matrix, and signal are deterministic code.
5. The model does not hire. Chat may state facts and the applicable rule. It refuses hiring, rejection, and adverse-action advice.
6. Access is applied before the model sees the case. Hidden sections are absent from the prompt, not filtered after the answer.

## 5. What ships in this repo

| Surface | Requirement it covers |
| --- | --- |
| `index.html` | Clickable prototype: queue, dashboard, cited report, SLA panel, adjudication, candidate portal, PDF / Excel / ZIP export. No backend. |
| `agent.html` | Live agent: editable fictional documents, real extraction, citation gate, SLA matrix, grounded chat. |
| `api/analyze.js` | `POST /api/analyze`. Extraction, gate, matrix, signal, audit event. |
| `api/ask.js` | `POST /api/ask`. Grounded chat filtered by access level, audit event. |

There is no build step. The key `ANTHROPIC_API_KEY` stays server-side.

All candidate names, employers, records, documents, and figures are fictional and self-generated. No Accurate Background production, test, or development data is used.

## 6. Functional requirements

### 6.1 Analyze

`POST /api/analyze` accepts `{ candidate: { name, role }, documents: [{ id, title, type, date, text }] }`.

Input limits, enforced before the model call:

- `documents` is a non-empty array of at most 12 items.
- Each document has an `id` and a string `text` of at most 20,000 characters.

The model returns sections among `identity`, `employment`, `education`, `criminal`, `credit`, `drug`. Document text is data. Instruction-like content inside a document is ignored.

Each finding has `kind` of `match`, `discrepancy`, `record`, or `note`, plus `claimed`, `verified`, `note`, and `cites`. A cite is `{ doc, excerpt }` with `excerpt` copied from that document, at most 200 characters.

A record the candidate did not disclose is kind `record` in `criminal`, cited to the record and to the disclosure answer when that answer is present.

The response is `{ signal, reason, mode, rules, sections, dropped, audit }`.

- `signal` is `critical`, `attention`, or `routine`.
- `mode` is `manual` or `auto`.
- `rules` is the sorted list of SLA rule ids that fired.
- `dropped` is how many findings the citation gate removed.
- `audit` records model, time, document ids, dropped count, and rule ids.

### 6.2 Citation gate

A cite survives only when its excerpt, after whitespace is collapsed and case is folded, is a substring of the named document. Findings other than `note` with zero surviving cites are dropped and counted. Sections with no remaining findings are omitted. Unknown section keys are omitted.

The UI reports the dropped count. A reviewer can see that unsourced claims were removed rather than silently kept.

### 6.3 SLA matrix and signal

Evaluated only on findings that survived the gate.

| Rule | Area | Fires when | Routing |
| --- | --- | --- | --- |
| 1.1 | Identity | Identity findings do not diverge | Auto |
| 2.1 | Employment | Employment findings do not diverge | Auto |
| 2.2 | Employment | A discrepancy or record in employment | Manual, attention |
| 3.1 | Education | Education findings do not diverge | Auto |
| 3.2 | Education | A discrepancy or record in education | Manual, attention |
| 4.1 | Criminal | Criminal findings do not diverge | Auto |
| 4.2 | Criminal | A discrepancy or record in criminal | Manual, critical |
| 5.1 | Credit | A discrepancy or record in credit | Manual, attention |
| 6.1 | General | Nothing above forced manual review | Auto, routine |

`critical` wins over `attention`, which wins over `routine`. The reason is up to three finding titles, or "All checks verified with no discrepancies."

The client-facing panel states the same rules in operational language (date windows, dollar thresholds, individualized assessment). The live matrix in `api/analyze.js` keys off finding kind and section, which is what the extractor is allowed to emit. The panel is read-only and visible to recruiters at Level 3 and above. Rule ids in the report open that panel.

### 6.4 Ask this report

`POST /api/ask` accepts `{ question, level, candidate, sections, documents }`. The question is required and at most 1,000 characters. Level is clamped to 1–5.

Sections below the caller's level are removed before the prompt is built. The assistant answers only from the remaining findings and documents, cites document ids inline, says plainly when the material does not contain the answer, and refuses hiring, rejection, and adverse-action advice. Answers are short plain text.

The prototype chat on `index.html` is scripted against the fictional cases and enforces the same refusals and level checks in the browser. The live chat on `agent.html` calls `/api/ask`.

### 6.5 Queue, report, and decision

The prototype queue ranks cases by signal and shows the reason on the case. Opening a case shows each check as stated against verified, with numbered citation chips. A chip opens the source and highlights the passage.

The recruiter records a human adjudication. The product does not write that decision back to a system of record in this MVP.

Exports (PDF, Excel, ZIP) are generated at the caller's access level. Locked sections export as locked, not as blank detail.

### 6.6 Candidate view

The candidate sees statuses, not the internal findings. They can respond to an invitation to supply context on a flagged item. That response is stored in the prototype session. It does not change the signal by itself. A person still adjudicates.

## 7. Access levels

| Level | Includes |
| --- | --- |
| 1 | Overall result and per-check status only |
| 2 | Identity, employment, and education detail, with sources. Chat unlocks. |
| 3 | Criminal record searches, and the SLA panel |
| 4 | Credit history for finance-sensitive roles |
| 5 | Drug screening and complete source access |

A section below the caller's level shows its status and a lock. The finding text stays hidden. Ask refuses questions whose answer lives in a hidden section.

## 8. Security architecture

```
documents (data, not instructions)
        │
        ▼
   LLM extraction          ← may be wrong, may hallucinate a cite
        │
        ▼
   citation gate           ← code; excerpt must occur verbatim in the named doc
        │
        ▼
   SLA matrix + signal     ← code; rule ids stamped on the result
        │
        ├──────────────► recruiter UI at the caller's level
        │
        ▼
   ask, after level filter ← hidden sections never enter the prompt
        │
        ▼
   audit event             ← one per analyze, one per ask
```

Controls in this MVP:

- The API key is an environment variable on the server. It is not shipped to the browser.
- Document text and questions are delimited as data in the prompt. The system instruction tells the model to ignore instructions found inside them.
- The gate does not trust the model's claim that an excerpt is real. It checks inclusion.
- Routing does not trust the model's judgment of severity. `evalSLA` assigns signal and mode.
- Access filtering for `/api/ask` happens in the function, before `fetch` to the model.
- Payload caps (12 documents, 20k characters, 1,000-character question) bound cost and prompt injection surface.
- Every analyze and ask call emits an audit event: model or event name, time, document ids or question length, level where relevant, dropped count, and rule ids.

Known limit of the MVP: the audit event is written to the function log. It is not yet an append-only store. The response field `audit` on analyze is the same record, returned so the demo can show it. A production version would append that record where the caller cannot rewrite it, and would authenticate the caller instead of trusting a `level` field from the browser.

## 9. Compliance mapping

This mapping is the product intent of the hackathon build. It is not a legal opinion, and the fictional cases are not consumer reports.

| Obligation | How the product treats it |
| --- | --- |
| FCRA purpose and consent | Source documents in the demo include an electronic consent line and a statement that the report is furnished for employment purposes. The product does not collect live consent. |
| Accuracy and traceability | A claim without a verbatim source is dropped. Surviving claims cite the document a reviewer can open. |
| Adverse action stays human | The assistant refuses hire, reject, and adverse-action advice. Rule 4.2 text on the panel states that a disclosed-or-not record requires individualized assessment before any adverse action. |
| EEOC individualized assessment | A criminal hit is a signal and a rule id, not a bar. The recruiter sees the record, the candidate's disclosure, and can request candidate context. The candidate view can answer that invitation. |
| Fair chance | Non-disclosure of a record raises the signal to critical and forces manual review. It does not auto-reject the case. Rule 6.1 auto-clears only when every section cleared. |
| Need-to-know | Criminal detail starts at Level 3, credit at Level 4, drug at Level 5. Exports and chat follow the same tiers. The candidate view is statuses only. |

## 10. Out of scope

- Live consent capture, permissible-purpose certification, or dispute handling.
- Writing an adjudication back to an order-management system.
- An append-only audit store, authentication, and server-side enforcement of level on the static prototype.
- Using any Accurate Background production or test data.
- Letting the model choose the signal, the rule, or the hiring outcome.

## 11. Acceptance

Prototype, no key:

- The critical case (Jordan Avery) opens from the queue. A citation chip highlights the source passage. `SLA 4.2` opens the rule.
- Level 2 hides criminal detail. Level 3 shows it and the SLA panel.
- Candidate view shows statuses and accepts an invitation response.
- PDF, Excel, and ZIP export at the current level, with locked sections marked locked.

Live agent, with `ANTHROPIC_API_KEY` via `vercel dev`:

- Run analysis. Findings cite the documents. The banner reports any dropped claims.
- Delete the court document or change the charge: the critical signal and rule 4.2 leave.
- Align the application's Meridian dates with the HR verification: the employment discrepancy leaves.
- Ask why the case needs review at level 3, then at level 2: the criminal answer locks.
- Ask whether to hire: the assistant refuses and leaves the decision human.

Guardrails that must stay true after any change to the pipeline:

- An excerpt that is not in the named document cannot survive the gate.
- Signal and rule ids come from `evalSLA`, not from model output.
- `/api/ask` does not put a below-level section in the prompt.
