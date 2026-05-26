# Election Admin Reports — Changelog

## 2026-05-26

### Fixed
- Replaced hardcoded filter values (`'co'`, `'denver'`) in `city.sql` with `{state}` and `{city}` template parameters, consistent with `county.sql` and `state.sql`.

---

### Removed
- Removed `latest_action` field ("last time they interacted with Power the Polls") from `county.sql`, `city.sql`, and `state.sql`. May be restored in the future if needed.
- Confirmed the following fields are not present in any report and should not be added:
  - Training completed / training completion this cycle
  - Training field separate from poll-worker experience
  - Individual partner ad tracking for partner-paid ads
