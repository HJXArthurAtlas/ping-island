# Experience themes and semantic feedback

Ping Island separates **what happened** from **how it is presented**. Product
and session code emits `AppSoundFeedbackEvent`; it must not name a bundled wav
file or choose a visual color directly.

## Theme contract

`ExperienceThemeID` is persisted in `AppSettingsStore` and currently has two
profiles:

| Theme | Visual direction | Recommended sound mode |
| --- | --- | --- |
| `standard` | restrained macOS-style controls | `builtIn` |
| `pixel` | square edges and monospaced UI details | `island8Bit` |

Selecting a profile applies its recommended sound mode. Users may subsequently
select a CESP/OpenPeon sound pack; that replaces sound playback only and does
not silently change the selected visual profile.

## Sound feedback

The five configurable notification events (`processingStarted`,
`attentionRequired`, `taskCompleted`, `taskError`, and `resourceLimit`) retain
their existing per-event setting and enable switch. `AppSoundFeedback` routes
them back to `AppSettings.playSound(for:)`.

Auxiliary events—client start, detached presentation, allow, scoped allow, and
deny—use the active sound mode. CESP v1 has no dedicated approval categories,
so those events map to compatible existing categories until the format defines
semantic approval categories. Keep those fallback mappings in
`AppSoundFeedbackEvent`, not in SwiftUI views.

## Confirmation controls

Use `ConfirmationActionButton` for actions that resolve a pending operation:

- `.approve` is green and plays accepted feedback.
- `.scopedApproval` is blue and plays scoped-allow feedback.
- `.deny` is red and plays rejection feedback.
- `.neutral` remains gray/white and does not imply approval or rejection.

Each role includes a visible icon and an accessibility hint; color is a
reinforcement, never the sole indication of action meaning. New confirmation
surfaces should use the shared role rather than adding per-screen colors.

## Verification

`PingIslandTests/ExperienceThemeTests.swift` covers the stable theme contract,
semantic sound mappings, and distinct confirmation roles.
`AppSettingsPersistenceTests` verifies theme persistence and recommended sound
mode application.
