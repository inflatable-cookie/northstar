# Knowledge

`docs/knowledge/` records the project's current truth. It is organized so
readers can find the facts they need and see which file owns each topic.

## Layout

```text
docs/knowledge/
  README.md        # index: topic → owning file
  vision.md        # what the project is for, and what it is not
  architecture.md  # system shape
  contracts/       # durable rules and interfaces
  domain/          # domain concepts, vocabulary and rules
  retired.toml     # concepts that no longer apply
```

Split a file when a topic outgrows it and update the index. Omit empty folders.

## Owning a fact

- Each fact has one owner. Other files link to it rather than restating it.
- Write current truth, not how it came to be. Git holds the history.
- Keep detailed design when it helps readers understand a complex system.
- When a change alters a durable fact, update its owner in the same change.
- If two files disagree, the index identifies which file owns the fact; fix
  the other copy.

## Retired concepts

`retired.toml` records concepts that no longer apply, so readers do not
mistake them for current truth. A retirement includes its replacement, owner,
and any relevant terms, paths or configuration keys.

`scripts/retired-concepts.py` reports matching live references. The retiring
change should remove or update those references; preserve immutable historical
evidence only when its contract requires that. The script's header documents
its exact matching rules.
