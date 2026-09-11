# UI execution guidance

Compact, provider-neutral guidance for the Build and Review routes. It assumes
the approved brief and consumer design authority, and it imposes no house
aesthetic. When consumer guidance conflicts with this file, the consumer wins.

## Hierarchy and layout

- Make the primary action and the current state obvious without reading
  everything.
- Group related information; separate unrelated actions.
- Prefer a single reading direction and a stable grid over many one-off
  alignments.
- Let density follow the user's task: operational surfaces favor scanability,
  marketing surfaces may favor space.
- Do not center-align long text, trap content in nested scroll areas, or let one
  element dominate without a reason in the brief.

## Typography

- Use the consumer type scale. Do not invent sizes to force a hierarchy.
- Keep line length comfortable and line height readable.
- Reserve weight and color emphasis for real priority; too much emphasis is
  none.
- Ensure numbers, timestamps, and identifiers align and remain legible.

## Color and contrast

- Use design-system tokens, not ad-hoc values.
- Meet contrast requirements for text, icons, focus rings, and state changes.
- Never encode meaning in color alone; pair it with text, shape, or icon.
- Check dark/light and forced-colors behavior when the envelope includes it.

## Icons and imagery

- Use the established icon set and keep stroke, size, and optical weight
  consistent.
- An icon without a label needs an accessible name and a widely understood
  meaning.
- Do not add decorative imagery that competes with the task.

## Copy

- Lead with the user's task, not the system's internals.
- Buttons describe the action; errors describe what happened and what to do
  next.
- Keep labels stable across related states; do not silently rename a control.
- Test with short, long, empty, and localized strings.

## Feedback and state

- Every action that takes time needs visible progress, and every state change
  needs an acknowledgement.
- Distinguish loading, empty, partial, error, permission, offline, and success.
  Empty states should explain how to proceed.
- Preserve user input across recoverable errors.
- Make destructive actions confirmable and reversible where the domain allows.

## Accessibility and input

- Use semantic elements and labels before ARIA.
- Keep a visible focus indicator and a logical focus order; manage focus on
  route, dialog, and async changes.
- Support full keyboard operation, including the recovery and error paths.
- Respect zoom and text scaling without clipping or overlap.
- Honor reduced motion; never make motion the only signal.
- Provide correctly sized pointer and touch targets with spacing.

## Responsiveness

- Define behavior at the required viewports, from narrow to wide, including
  overflow, wrapping, and truncation.
- Decide what collapses, reorders, or hides, and keep the primary action
  reachable.
- Test realistic content ranges: short, typical, long, missing, and localized,
  not placeholder strings.

## Motion

- Use motion to explain change, not to decorate.
- Keep durations and easing consistent with the design system.
- Provide a non-motion equivalent for anything motion communicates.

## Common model-generated UI failures

Watch for and repair these:

- a happy path with no empty, loading, error, permission, or offline state;
- invented colors, spacing, or type sizes that bypass design tokens;
- centered or card-heavy layouts that bury the primary action;
- placeholder copy ("Lorem", "Item 1", "Coming soon") left in place;
- icon-only controls with no accessible name;
- decorative gradients, shadows, or animation that carry no meaning;
- focus lost after dialogs, route changes, or async updates;
- color-only status or validation;
- fixed widths that break on long content or narrow viewports;
- a second design language layered on the existing one;
- duplicate or contradictory calls to action;
- silent failure with no feedback or recovery path.
