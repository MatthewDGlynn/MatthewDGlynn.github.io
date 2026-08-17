# Calindex Links

Static, privacy-preserving link previews and universal-link association files for Calindex.

Event cards use URLs shaped like:

```text
https://matthewdglynn.github.io/calindex/event/#<base64url-event-payload>
```

The encoded event is stored in the URL fragment. Browsers and link-preview crawlers request only the static path, so the host never receives the title, time, place, notes, or other event fields. An installed Calindex app opens the universal link directly; the static page offers a custom-scheme fallback and App Store link.

The Open Graph artwork is generated from the shipping Calindex icon:

```sh
swift scripts/generate_event_card.swift /path/to/CalindexAppIcon.png calindex/assets/calindex-event-card.png
```
