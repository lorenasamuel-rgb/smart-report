# Smart Report user guide

How to open the queue, read a report, and record a decision.

Every candidate, employer, record, and document in this demo is fictional.

## What the report does

Each case arrives with one signal and a sentence that states why. The report shows what the candidate stated next to what was verified. Every claim points to its source document and to the SLA rule that routed the case.

The product recommends. Hiring, rejection, and adverse action stay with a person.

There are two surfaces:

| Where | What it is for |
| --- | --- |
| `index.html` | Queue, cited report, SLA, adjudication, candidate portal, and export. Opens in a browser with no API key. |
| `agent.html` | Live analysis: editable documents, verbatim citation extraction, and grounded chat. Needs the API. |

## How to open it

Prototype: open `index.html` in a browser, or serve the folder with any static server.

Live agent, from the repo root:

1. Install the CLI: `npm i -g vercel`
2. Store the key on the server: `vercel env add ANTHROPIC_API_KEY`
3. Run `vercel dev`
4. Open `http://localhost:3000` for the prototype and `http://localhost:3000/agent.html` for the agent

The key stays on the server. The browser never receives it.

## Header

At the top, next to the **Smart Report** name, the controls apply to the whole screen.

- **Recruiter view** is the queue and the internal report.
- **Candidate view** is what the candidate sees: the status of each check, with no findings and no sources.
- **Access level** exists only in the recruiter view. The note beside the selector says what that level unlocks.
- **SLA criteria** appears from Level 3 and opens the rule panel. In the prototype the level is a demo selector. In production it would come from the authenticated user.

## Signals

The queue ranks cases by signal. Critical sits at the top.

| Signal | Meaning |
| --- | --- |
| Critical | An undisclosed criminal record, or another finding the matrix sends to urgent human review. |
| Attention | An employment, education, or credit discrepancy that needs review, without the weight of an undisclosed record. |
| Routine | Checks match, or the case is still in progress with nothing that forces review. |

On each row, **Why this signal** is the reason sentence. The progress (`6/6`) is how many checks are finished. **Due in** is the deadline.

## Recruiter queue

**Screening queue** opens with **Live intake**. A fictional screening arrives every minute. **Start** and **Stop** run and pause that flow. The clock shows the time until the next one.

Dashboard tiles filter the list. Click the active tile again to see everyone.

- **Active screenings** — all cases
- **Critical signals** / **Attention signals** — by signal
- **Discrepancies flagged** — cases with at least one discrepancy
- **Complete and clear** — finished with nothing outstanding

The **Screening status** bar filters by progress: **Needs review**, **In progress**, **Complete and clear**.

Search accepts a name, a reference (`SR-…`), or an order number (`ORD-…`). **Date** narrows by order date (**Ordered**), deadline (**Due**), completion (**Completed**), or any of them (**Any date**). If nothing matches, **Show all** clears the filter, the search, and the date.

The checkbox on the left of a row selects that case for export. It does not open the report. Click the rest of the row to open it.

### Status bot

The face at the top right counts cases that still need you: review status or a critical signal, and no decision recorded in this session.

- Green: that list is empty. The tooltip says **Queue is clear.**
- Orange: cases need you, and none of them are critical.
- Pink: at least one case is critical.

The number is the count. Click the bot to see the name, the suggested next action, and the deadline. Click a name to open that report. A new screening makes the bot pulse for a few seconds. The bot is hidden in **Candidate view**.

## Reading a report

The top shows the name, role, package, signal, and the **Why this case is…** banner. The grid shows Report ID, order number, dates, finished checks, and adjudication. Chips such as **SLA 2.2** and **SLA 4.2** open the rule that routed the case.

Each section has a pill: `L2+`, `L3+`, `L4+`, or `L5+`. That number is the minimum level required to see the detail. Below it, the section shows its status and a lock. The finding text stays hidden. At Level 1 the whole report is a status list.

Inside an unlocked section, each finding shows:

- **Match** — stated and verified agree.
- **Discrepancy** or **Check** — they do not. Critical is pink, attention is orange.
- **Candidate stated** — what the person wrote.
- **Smart Report verified** — what the source confirmed.
- A number beside the title — the citation.

Click the number. A side panel opens the document and highlights the passage. Close it with **✕** or by clicking outside.

**Back to queue** returns to the list.

## Access levels

The level applies to the screen, the chat, and the export. A locked section exports as locked, with the level it requires, not as a blank field.

| Level | What it opens |
| --- | --- |
| 1 | Overall result and the status of each check. No findings, no sources, no chat. |
| 2 | Identity, employment, and education, with sources. Chat turns on. |
| 3 | Criminal record search and the **SLA criteria** panel. |
| 4 | Credit history, for finance-sensitive roles. |
| 5 | Drug screening and full source access. |

Asking the chat about something in a hidden section does not reveal it. The answer says that material requires a higher level.

## Ask this report

**Ask this report** appears from Level 2, above the sections. Answers use only this case's sources, within your level. Chips suggest questions already prepared for that candidate. You can also type and click **Ask**.

Useful questions: why the signal is what it is, what the employer confirmed, what the SLA rule says, which checks matched, what the status is.

If the question is whether to hire, reject, or make the decision, the answer refuses and leaves the case with you. Numbers and **SLA** chips inside an answer open the same source or the same rule as the report.

In the prototype, answers are scripted for the demo cases. On the live agent they come from the model, after the level filter removes hidden sections from the prompt.

## Recording a decision

When the matrix requires human review, the **Recruiter adjudication** block appears on the report.

1. Read the banner, the findings, and the citations.
2. If a finding asks for the candidate's side, click **Request candidate context**. The button becomes **Context requested ✓**.
3. **Start adverse action** stays disabled until that request is sent. The hint says why: fair chance, context comes before the action.
4. **Mark eligible** records that you consider the person eligible. It does not require the context request.
5. **Undo** clears the mark for this session. This MVP does not write the decision back to an order system.

A case the matrix auto-clears (rule 6.1) does not show these buttons. Adjudication shows as done by Smart Report.

Requesting context does not change the signal. The candidate's reply, when there is one, is attached for you to read. The decision stays yours.

## Candidate view

**Candidate view** hides the level, the SLA panel, and the status bot. The line under the title states the limit: the candidate sees whether each check is **Complete** or **Not complete**. Discrepancies, records, and sources do not appear.

The name buttons at the top are a demo switcher, so you can preview each person. In production a candidate would see only their own case.

If the recruiter already requested context on that case, the notice **Your reviewer invited you to add context** appears, with **Share your context**. After it is sent, the screen confirms the note was attached to the reviewer's report. The footer states the right to a copy and to a dispute. This prototype does not open a real dispute flow.

## Export

On the queue:

- Check one or more cases. **Excel (n)** downloads `smart-report-status.xlsx` with name, role, location, IDs, signal, status, adjudication, due date, and checks. With nothing selected, Excel stays off.
- **Export ZIP (all)** packs one PDF per case in the whole queue. With cases checked, the ZIP contains only those (`smart-report-reports.zip`).

Inside a report:

- **PDF** downloads that person's report at the current level. A locked section is included as locked.
- **Print** opens the browser print dialog. If print is unavailable, the button copies a text summary instead.

The file records the access level used for the export.

## SLA rules

**SLA criteria** (Level 3 and above) opens the client matrix, read-only. The rule that fired on the open case is highlighted when you arrive from an **SLA** chip.

| Rule | Fires when | Routing |
| --- | --- | --- |
| 1.1 | Identity matches | Auto |
| 2.1 | Employment is inside the window (title and dates, up to 3 months) | Auto |
| 2.2 | Employment dates differ by more than 3 months, or the title does not match | Review, attention |
| 3.1 | Degree conferred within 6 months of the stated date | Auto |
| 3.2 | Conferral differs by more than 6 months, or the institution does not match | Review, attention |
| 4.1 | No criminal records | Auto |
| 4.2 | A record the candidate did not disclose. Individualized assessment before any adverse action | Review, critical |
| 5.1 | Open collections above $5,000 on a finance-sensitive role | Review, attention |
| 6.1 | Every section above cleared | Auto, routine |

Critical wins over attention, which wins over routine. Rule 4.2 does not reject the case by itself. It requires human review.

## A short path through the prototype

1. Stay on **Recruiter view**, Level 3.
2. Open Jordan Avery (`SR-2026-1187`), the critical case at the top.
3. Click the Cook County record citation and read the highlighted passage.
4. Click **SLA 4.2** and read the rule.
5. Switch to Level 2 and watch the criminal section lock. If the chat is asked about the record, that answer locks too.
6. Return to Level 3, click **Request candidate context**, and only then **Start adverse action** is available. Use **Undo** if you want to clear the mark.
7. Switch to **Candidate view**, pick the same person, and if context was requested, use **Share your context**.

## Live agent

On `agent.html` the Jordan Avery documents are editable. **Run analysis** sends the case: the model extracts findings with verbatim excerpts, code drops any citation that is not in the named document, and the SLA matrix sets the signal and the rules. The banner reports how many findings were dropped.

**Access level** on this page filters the chat only. Run the analysis before you ask. **Ask this report** appears after the result.

To watch the matrix react:

- Delete the court document, or change the charge so the criminal finding disappears: the signal leaves critical and rule 4.2 leaves the list.
- Align the application's Meridian dates with the HR verification: the employment discrepancy disappears.
- Ask why the case needs review at Level 3, then again at Level 2: the criminal answer locks at the lower level.
- Ask whether to hire: the answer refuses.

## What this report does not do

- It does not recommend hire, reject, or adverse action.
- It does not change the signal because the candidate answered the invitation.
- It does not write the adjudication back to an order system.
- It does not collect live consent or open a dispute.
- It does not use production data. The demo cases are fictional.
