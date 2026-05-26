# Election Admin Reports — Changelog

## 2026-05-26

### Added
- Added `first_time_poll_worker`, `prior_experience_being_poll_worker`, and `fluent_second_language` fields to `county.sql`, `city.sql`, and `state.sql`.
- Added `created_at >= '2025-01-01'` filter on page 12 signups to restrict all reports to the current cycle (2025–2026). Reports return all cycle-to-date signups (aggregate), not a rolling 7-day window.

### Removed
- Removed `languages` field (specific languages spoken) from all three reports. `fluent_second_language` is retained.

### Fixed
- Replaced hardcoded filter values (`'co'`, `'denver'`) in `city.sql` with `{state}` and `{city}` template parameters, consistent with `county.sql` and `state.sql`.

---

### Removed
- Removed `latest_action` field ("last time they interacted with Power the Polls") from `county.sql`, `city.sql`, and `state.sql`. May be restored in the future if needed.
- Confirmed the following fields are not present in any report and should not be added:
  - Training completed / training completion this cycle
  - Training field separate from poll-worker experience
  - Individual partner ad tracking for partner-paid ads
