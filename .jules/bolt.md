# Bolt's Performance Journal

This file records critical codebase-specific performance learnings and patterns.

## 2026-11-03 - Reuse DateFormatter instances across XML delegate parsing
**Learning:** `DateFormatter` (like `ISO8601DateFormatter`) in Apple Foundation is very expensive to instantiate due to ICU data loading and locale resolution. Several XML parser delegates were instantiating new `DateFormatter` objects inside `didStartElement` / `didEndElement` for each item. Reusing formatters as delegate properties eliminates significant heap churn and parsing latency during Subsonic and Ampache syncing.
**Action:** Always check XML and JSON parsing delegate loops for transient `DateFormatter` / `ISO8601DateFormatter` creations and reuse them across parse cycles.
