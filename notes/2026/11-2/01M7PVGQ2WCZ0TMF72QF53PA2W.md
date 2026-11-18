---
id: 01M7PVGQ2WCZ0TMF72QF53PA2W
created: 2026-11-18T08:14:04.89209Z
updated: 2026-11-18T10:11:15.326888Z
type: task
title: Laid-out flowcharts route connections around steps, and no connection label is hidden
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1931
sprint: s6y6p7g
comments:
- id: 01M7PXHSRRAV62D59MAZ96Y4WM
  author: Steve Vine
  at: 2026-11-18T08:49:37.560434Z
  text: |-
    Done — PR #1919, merged a2f9a1cf.
    Connections now run round steps, never through them. This holds on the canvas and in the picture used for the document, PDF, Word and downloads, after Tidy up and for flowcharts placed by hand. A Decision's Yes and No leave by different sides, and every connection's label sits clear of every step and is drawn over the lines.
    Tidy up (and with it imports, text-diagram conversion and Polaris drafts) now lays the flow out in reading order:
    - a step is never placed after the step it leads into;
    - a loop back up the flow is routed round the outside;
    - a branch that rejoins, such as a hand-off to End, sits beside the main path;
    - steps slightly out of line with the one before are straightened.
    A shape grows to hold its whole label when laid out, and the picture uses smaller type rather than cutting a label short ("Approve…").
    Assumption: lines can still cross other lines, but never steps.
    To check on staging: Tidy up Tester A's request flow (Hand-off joined to End), re-import the Minor and Major Technology pages, and convert the Known fix? text diagram. Look for lines going round steps and the Yes/No labels in view.
- id: 01M7Q278QYPD0J29EQ1NNJWJ4B
  author: Steve Vine
  at: 2026-11-18T10:11:15.326631Z
  text: |-
    Pre-UAT on staging 27151cd9 — Failed
    No connection passes through a step any more, the labels are visible, and the steps come in flow order. But two layouts still draw connections on top of each other along shared lines, so the picture still shows the wrong flow. A tall flowchart is also cut off in the PDF.
    Tested by tester A as E2E Admin A on the COM-1904 request flow (I joined the Hand-off to End again, then used Tidy up). I also used a new document, "E2E pre-UAT COM-1931 text diagram conversion (draft)": a Mermaid diagram with "Known fix?", a long decision ("Approve an emergency change before the change advisory board meets?") and a No loop back to Investigate, converted with Turn into a flowchart and published.
    - No connection passes through a step, including loops back: Passed. For every connection on the canvas I sampled its route against every step it doesn't start or end at. None crossed a step, after Tidy up both ways and after converting. The loop back to Investigate goes round the outside.
      - Tester B, on Steve's Lucidchart pages (read and Cancel only): on Minor Technology, the Escalate? (No) line now goes round Close Incident back to Investigate, with Yes and both No labels in view. On Major Technology (44 shapes, 7 lanes) it's dense, but no line goes through a step. Screenshots: re-minor-technology-zoom.png, re-major-technology-zoom.png.
    - A branch that rejoins sits beside the main path, in flow order: Passed for order. Left to right reads Start, Receive, Check, Approved?, then Do the work / Hand-off, Write up, Email, End (re-01-tidy-LR.png, re-02-tidy-TB.png). The plain text agrees.
    - Every label is visible and a long decision label wraps: Passed. Yes and No are both visible and no step covers them. The long decision wraps onto four lines inside a bigger diamond, both on the canvas and in the PDF.
    - The same holds in the PDF/Word picture: Failed, for these reasons.
      DEFECT 1, connections drawn along the same line. In the converted flow, the route for "Known fix? → Yes → Apply the fix" runs down the same vertical line as "Known fix? → No → Approve…", straight into the Approve diamond. So Yes appears to go to Approve too. Further down it shares the right-hand line with "Approve → No → Investigate". On the canvas: re-04-converted-canvas.png and re-05-converted-zoom.png. In the PDF: re-convert-v2-p3.png. In the request flow, Hand-off → End and Write up the change → Email the confirmation meet at the same arrowhead into "Email the confirmation", so the Hand-off appears to lead to Email (re-v4-p4-hi.png and the canvas, re-01-tidy-LR.png). Lines no longer go through steps, but these still read as the wrong flow.
      DEFECT 2, a tall flowchart is cut off in the PDF. The converted 8-step flow (Top to bottom) doesn't fit a portrait page. Page 2 has only the heading. The picture on page 3 runs past the bottom of the page, and "Close the incident" never appears: it's missing from the page's text. Page 4 holds only the caption (re-convert-v2-p2.png, -p3.png, -p4.png, re-convert-v2.pdf). Steps: make that document from the Mermaid shown above, convert it, publish, and export the PDF.
    - Also: re-exporting the wide request flow on its landscape page still gives 2 parts, not the whole flowchart. There's no lone "End" part now: part 2 has Do the work through End (re-v4.pdf, pages 3–4).
    - Observation: straight after converting, opening the canvas and pressing Done, I published, and the PDF said "Not yet drawn — open the document in Compass" (re-convert-p2.png). The picture was saved only when I opened the Edit tab again, which left "draft changes" and needed a second publish.
    Screenshots and files: ~/compass-uat/s6y6p7g/COM-1931/
assignee: steve
label:
- bug
priority: high
task_status: review
---
Pre-UAT, 2026-11-18. After Compass lays a flowchart out (Tidy up, an import with no positions, a converted text diagram, or a Polaris draft), connections can run through other steps and hide their labels. The picture then shows the wrong flow, though the steps in words are right.
- COM-1913: the Yes line (Known fix? → Apply the fix) runs under "Investigate" with its Yes label hidden (~/compass-uat/s6y6p7g/COM-1913/03b-convert-preview-zoom.png, 08-converted-canvas.png).
- Lucidchart import of Steve's Minor Technology page: the line from Escalate? (No) back to Investigate runs through "Close Incident" (COM-1912/02b-minor-technology-zoom.png). Major Technology has several lines through boxes.
- Also seen: a long decision label is cut short in the import preview ("Approve…").
- Tester A (COM-1904): when a branch rejoins the flow (e.g. a Hand-off connected to End), Tidy up puts every step in one row or column, the "No" connection is drawn behind four shapes, and a step can land after the step it leads into (~/compass-uat/s6y6p7g/COM-1904/04-tidy-top-bottom.png, 05-tidy-left-right.png, 16-v2-chart.png).

**Done when**
- After Tidy up (and every automatic layout: imports, conversion, Polaris), no connection passes through a step it doesn't start or end at, including loops back up the flow.
- A branch that rejoins the flow is laid out beside the main path, and every step comes in flow order: a step is never placed after the step it leads into.
- Every connection's label is visible and not covered by a step. A long decision label wraps instead of being cut short.
- The same holds in the picture used for PDF/Word and downloads.
- Tests cover a loop back up the flow, a branch that rejoins, and a branch that crosses a lane, using made-up charts shaped like the Lucidchart fixture (not Steve's file).

Independent: frontend layout and render.