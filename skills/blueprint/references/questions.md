# Questions

Ask exactly one question per message. Output it in the conversation (NOT in the plan file):

```
**Q4. [Question text]**

_Context: [1-2 line snippet from the plan]_

a) Option A
b) Option B
c) Option C
d) Other (describe)

> Answer with a letter like `b` or write freely. Reply `skip` to move on, or `done` to end Q&A and generate the plan.
```

Number questions sequentially across the whole session (Q1, Q2, Q3, ...) so the transcript stays easy to reference — do not restart numbering after an answer.

Leave a blank line between the question text, context line, options, and the answer hint. For questions with clear enumerable options, provide lettered choices. Always include a final "Other (describe)" option so the user can provide their own answer. If a question is better answered with free text, omit the choices (keep the answer hint, dropping the letter part). For select-all-that-apply questions, add "(select all that apply)" after the question text.

Focus on decisions that meaningfully affect the implementation — not trivial or obvious choices.
