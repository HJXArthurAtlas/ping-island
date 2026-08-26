import SwiftUI

enum PixelExperienceTheme {
    static let definition = IslandExperienceTheme(
        id: .pixel,
        metadata: ExperienceThemeMetadata(
            displayName: "Pixel",
            description: "像素网格、直角控件与 8-bit 提示反馈组成的完整参考实现。",
            extensionNote: "它展示如何同时替换表面、控件、动效节奏与辅助提示音。"
        ),
        visual: ExperienceThemeVisualTokens(
            islandSurface: Color(red: 0.025, green: 0.06, blue: 0.10),
            islandTopSeparator: Color(red: 0.22, green: 0.84, blue: 0.88).opacity(0.76),
            detachedSurface: Color(red: 0.03, green: 0.08, blue: 0.13),
            settingsSurface: Color(red: 0.025, green: 0.055, blue: 0.095),
            settingsSidebarSurface: Color(red: 0.04, green: 0.10, blue: 0.15),
            settingsDetailSurface: Color(red: 0.025, green: 0.07, blue: 0.11),
            settingsCardSurface: Color(red: 0.055, green: 0.13, blue: 0.18),
            settingsCardBorder: Color(red: 0.25, green: 0.77, blue: 0.80).opacity(0.42),
            previewSurface: Color(red: 0.035, green: 0.09, blue: 0.14),
            previewSidebarSurface: Color(red: 0.08, green: 0.19, blue: 0.24),
            primaryText: Color(red: 0.90, green: 1.00, blue: 0.97),
            secondaryText: Color(red: 0.66, green: 0.86, blue: 0.86),
            accent: Color(red: 0.24, green: 0.86, blue: 0.88),
            controlCornerRadius: 2,
            settingsCornerRadius: 4,
            sectionCornerRadius: 3,
            controlFontDesign: .monospaced,
            usesPixelGrid: true,
            usesGlassMaterial: false
        ),
        interaction: ExperienceThemeInteractionTokens(
            approve: ConfirmationActionAppearance(
                foreground: Color(red: 0.93, green: 1.00, blue: 0.93),
                background: Color(red: 0.08, green: 0.42, blue: 0.22),
                border: Color(red: 0.32, green: 0.98, blue: 0.53)
            ),
            scopedApproval: ConfirmationActionAppearance(
                foreground: Color(red: 0.91, green: 0.97, blue: 1.00),
                background: Color(red: 0.10, green: 0.28, blue: 0.64),
                border: Color(red: 0.34, green: 0.70, blue: 1.00)
            ),
            deny: ConfirmationActionAppearance(
                foreground: Color(red: 1.00, green: 0.93, blue: 0.93),
                background: Color(red: 0.58, green: 0.12, blue: 0.20),
                border: Color(red: 1.00, green: 0.42, blue: 0.48)
            ),
            neutral: ConfirmationActionAppearance(
                foreground: Color(red: 0.86, green: 0.95, blue: 0.95),
                background: Color(red: 0.14, green: 0.23, blue: 0.28),
                border: Color(red: 0.41, green: 0.70, blue: 0.72).opacity(0.72)
            )
        ),
        motion: ExperienceThemeMotionTokens(
            controlPressScale: 0.97,
            controlPressDuration: 0.10,
            panelResponse: 0.32,
            panelDampingFraction: 0.86
        ),
        sound: ExperienceThemeSoundProfile(
            recommendedMode: .island8Bit,
            auxiliaryCues: [
                .clientStarted: ExperienceThemeSoundCue(
                    systemSound: .hero,
                    island8BitSound: .bootJingle,
                    soundPackFallback: .processingStarted
                ),
                .islandDetached: ExperienceThemeSoundCue(
                    systemSound: .pop,
                    island8BitSound: .bubblePop,
                    soundPackFallback: .processingStarted
                ),
                .approvalAccepted: ExperienceThemeSoundCue(
                    systemSound: .ping,
                    island8BitSound: .itemPickup,
                    soundPackFallback: .attentionRequired
                ),
                .approvalScoped: ExperienceThemeSoundCue(
                    systemSound: .glass,
                    island8BitSound: .menuSelect,
                    soundPackFallback: .attentionRequired
                ),
                .approvalRejected: ExperienceThemeSoundCue(
                    systemSound: .basso,
                    island8BitSound: .hurt,
                    soundPackFallback: .taskError
                )
            ]
        )
    )
}
