---
name: blueprint
description: Start a new plan-writing session. Explores the codebase and asks clarifying questions.
---

## Blueprint — Start plan session

Start a new plan-writing session. Help the user write an implementation plan through multi-round Q&A.

### Step 1: Parse arguments and select template

Parse the user's message for the feature description.

Read [references/templates.json](references/templates.json) to get the available templates. Ask the user which template they'd like to use — one per template, using the template's `name` as the label and `description` as the description. Always include an "Other" option so the user can describe a custom template.

This is the ONLY time you should ask a template selection question during the session.

### Step 2: Read the plan template

Read the selected template's `prompt` field to understand the structure and level of detail expected. If the user selected "Other", use their custom description as the template prompt.

Your questions should match the template's level and perspective.

### Step 3: Explore the codebase

Explore the project to understand:
- The project structure, key modules, and architecture
- Existing patterns and conventions
- Files and systems relevant to the user's request

Spend real effort here. Read actual source files.

### Step 4: Ask clarifying questions

Help the user think through everything they'd need to answer in order to write that plan well.

Based on the codebase exploration, ask ONE clarifying question following the format in [references/questions.md](references/questions.md). Ask exactly one question per message — never batch multiple questions, even if several topics are pending. Keep a mental list of remaining topics and work through them one at a time.

Guidelines:
- Keep text around the question brief — a sentence or two of context at most, not a full analysis
- Gather facts before asking — if something can be determined by reading code, searching docs, or looking up external references, find the answer yourself. Do not make subjective decisions on behalf of the user
- Look up external documentation, APIs, or tools when relevant
- Ground questions in what you found in the codebase — do NOT ask questions whose answers are already obvious from the code
- Questions must match the level and perspective of the selected template — if the template asks about external behavior, ask about external behavior. If it asks about implementation details, ask about implementation details
- Users generally expect to continue existing patterns and expand their system — only question existing patterns when the user's change clearly conflicts with them. Focus on what's new or ambiguous
- Do NOT ask questions about the plan template itself — ask questions that help define what to build
- Do NOT ask about implementation details unless the plan template explicitly calls for them

### Step 5: Continue Q&A

Wait for the user to respond. Accept answers in any format:
- Shorthand: a bare letter like `b`
- Prose: natural language answers
- Mixed: `b, but only for logged-in users`

When they answer:
- If they answered with a follow-up question of their own, answer it (or finish the discussion with them) before moving on
- Acknowledge briefly
- Show the updated refined prompt — take the original feature description and add bullet points (using `*` syntax) incorporating all clarifications so far. Follow the rules in [references/refine-prompt.md](references/refine-prompt.md). Display it in a blockquote so the user can see how their answers are shaping the plan.
- Add a one-line detail check (see "Detail check" below)
- Ask the NEXT single question, using the same format as Step 4. It may be a follow-up to their answer or a new topic that still needs discussion.
- If they reply `skip`, move on to the next question without recording an answer
- Keep asking one question at a time until the user ends Q&A

**Ending Q&A.** The user can end Q&A at any moment, in either of two ways:
- Replying `done` (or any clear equivalent: "generate", "stop", "that's enough")
- Invoking the blueprint-generate skill themselves

When the user signals they are done, invoke the blueprint-generate skill to generate the plan. If your harness cannot invoke skills programmatically, read and follow `../blueprint-generate/SKILL.md` directly.

IMPORTANT: Do NOT end Q&A on your own — even when the detail check says coverage is complete, offer the next question and let the user decide. Do NOT generate the plan until the user signals done. Do NOT write or modify any code files — you are only gathering information.

### Detail check

After each answer (before asking the next question), append one line assessing whether enough detail has been captured to write a good plan. Measure against the sections of the selected template: which sections could already be written well from the answers so far, and which are still thin.

Format:

```
**Detail check:** solid on overview and expected behavior; still thin on error handling and testing.
```

Once every template section has enough detail, say so explicitly:

```
**Detail check:** all template sections have enough detail — reply `done` to generate the plan, or keep going to refine further.
```

Keep it to one line. Do not list every section every time — name only what changed or what is still open.

### Progress indicator

Once a feature description has been provided and a template selected, append a single progress line at the end of **every** message. Do NOT show the progress line before then (e.g. when asking for a missing feature description or during template selection).

The line shows all four workflow phases using `✓` (completed), `●` (active), `○` (pending). Explore completes before the first user-visible question, so always show:

```
✓ Explore  ● Plan  ○ Write  ○ Refine
```

Place the line after all other content, separated by a blank line.
