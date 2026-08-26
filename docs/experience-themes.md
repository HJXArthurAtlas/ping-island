# Experience themes

Ping Island ships **compiled-in experience themes**. An experience theme owns
the presentation decisions that need to stay coherent across a native app:

```text
IslandExperienceTheme
├── Visual       surfaces, borders, corner geometry, typography, grid treatment
├── Interaction  approve / scoped-approve / deny / neutral action appearance
├── Motion       press feedback and panel-transition timing
└── Sound        recommended source and semantic auxiliary-event cues
```

This is deliberately different from a CESP/OpenPeon sound pack. A sound pack
is an optional **audio override**; it never changes the selected theme's UI,
icons, geometry, or motion.

## For users

Choose a theme from **Settings → Sound → Experience theme**.

| Theme | Experience |
| --- | --- |
| Default | The native macOS-oriented baseline: soft continuous corners, glass-backed settings surfaces, restrained motion, and system-sound recommendations. |
| Pixel | The reference theme: grid-backed Island and detached surfaces, square controls, pixel action glyphs, higher-contrast semantic controls, and 8-bit sound recommendations. |

Selecting a theme applies its recommended sound mode. The five notification
stages—processing, attention, completion, error, and resource limit—remain
individually configurable in the Sound settings. A user can also select a local
CESP/OpenPeon pack afterwards; that replaces audio playback only.

Confirmation actions retain one meaning in every theme:

- Green: allow this operation.
- Blue: allow within the current scope or session.
- Red: deny the operation.
- Gray/white: neutral hand-off actions, such as opening the originating app.

Buttons also retain text labels, icons, accessibility hints, and reduced-motion
safe press feedback; color is never the only indication of meaning.

## Architecture

The source is intentionally divided by responsibility:

```text
PingIsland/Core/
├── ExperienceThemeID.swift        persisted ID and action semantics
└── AppSoundFeedback.swift         semantic lifecycle/action event entry point

PingIsland/UI/Themes/
├── ExperienceTheme.swift          token contract and SwiftUI Environment key
├── DefaultExperienceTheme.swift   Default implementation
├── PixelExperienceTheme.swift     Pixel reference implementation
└── ExperienceThemeRegistry.swift  built-in registration point

PingIsland/UI/Components/
└── ExperienceThemeComponents.swift shared themed confirmation controls/previews
```

`AppLocalizedRootView` injects the selected `IslandExperienceTheme` into the
SwiftUI environment. Any child view reads `@Environment(\.islandExperienceTheme)`
instead of reaching into settings or defining a local palette. This lets docked
Island, detached bubbles, settings surfaces, and confirmation controls react to
one persisted selection.

Session and UI code emits `AppSoundFeedbackEvent`, not a filename. The five
configurable lifecycle events still route through `AppSettings.playSound(for:)`.
For auxiliary events—client start, detached presentation, allow, scoped allow,
and deny—the active theme supplies a `ExperienceThemeSoundCue`.

CESP v1 has no dedicated approval or detached-presentation categories. Theme
sound profiles therefore define a documented fallback to compatible existing
categories when a CESP pack is active. Keep that compatibility behavior in the
sound profile, never in an individual SwiftUI view.

## Adding a built-in theme

Themes are code-defined in this release; third-party UI theme bundles are not a
runtime extension point yet. To add a first-party theme:

1. Add a stable persisted case to `ExperienceThemeID` and its recommended sound
   mode. Do not rename an existing raw value.
2. Create `PingIsland/UI/Themes/<Name>ExperienceTheme.swift` with one complete
   `IslandExperienceTheme` definition. Supply every Visual, Interaction, Motion,
   and auxiliary Sound token.
3. Register the definition in `ExperienceThemeRegistry.all`.
4. Use semantic components such as `ConfirmationActionButton`; do not add
   per-screen approval colors or direct bundled sound names.
5. Add registry and sound-profile assertions to `PingIslandTests/ExperienceThemeTests.swift`.
6. Update the user-facing theme table in `README.md` and this document.

The `PixelExperienceTheme` is the reference implementation. It demonstrates
surface treatment, geometry, icon rendering, action roles, motion values, and
sound cues in a single definition file.

## Verification

`PingIslandTests/ExperienceThemeTests.swift` verifies that:

- every persisted theme ID is registered exactly once;
- Default and Pixel keep distinct visual contracts;
- profile recommendations match persisted selection behavior;
- every auxiliary event has a cue in every built-in theme; and
- confirmation roles keep distinct semantic intent.

`AppSettingsPersistenceTests` verifies theme persistence and application of the
recommended sound mode. Run the app-level test target as well as the Prototype
suite before release.
