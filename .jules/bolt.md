# Bolt's Performance Journal

This file records critical codebase-specific performance learnings and patterns.

## 2026-11-03 - Reuse DateFormatter instances across XML delegate parsing
**Learning:** `DateFormatter` (like `ISO8601DateFormatter`) in Apple Foundation is very expensive to instantiate due to ICU data loading and locale resolution. Several XML parser delegates were instantiating new `DateFormatter` objects inside `didStartElement` / `didEndElement` for each item. Reusing formatters as delegate properties eliminates significant heap churn and parsing latency during Subsonic and Ampache syncing.
**Action:** Always check XML and JSON parsing delegate loops for transient `DateFormatter` / `ISO8601DateFormatter` creations and reuse them across parse cycles.

## 2026-11-11 - Fast-path ASCII and scalar checks in section indexing avoids CharacterSet heap churn
**Learning:** `CharacterSet(charactersIn:)` and `rangeOfCharacter(from:)` bridge Swift strings into CoreFoundation `NSCharacterSet` bitsets, allocating heap objects on every call. In `String.sectionInitial`, which is called for every entity during library synchronizations and table sectioning, checking `firstChar.isASCII` and comparing `scalar.value` directly bypasses string folding and CharacterSet allocations, providing a ~4x speedup for typical music library collections.
**Action:** In high-frequency string classification or parsing routines, check ASCII/scalar ranges directly before falling back to Foundation `CharacterSet` or Unicode normalization.
