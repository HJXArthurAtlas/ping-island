import SwiftUI

enum DefaultExperienceTheme {
    static let definition = IslandExperienceTheme(
        id: .standard,
        metadata: ExperienceThemeMetadata(
            displayName: "默认",
            description: "克制、清晰的 macOS 体验，适合长时间使用。",
            extensionNote: "圆角、半透明层级和系统提示音构成默认体验。"
        ),
        visual: ExperienceThemeVisualTokens(
            islandSurface: .black,
            islandTopSeparator: .black,
            detachedSurface: .black,
            settingsSurface: .clear,
            settingsSidebarSurface: Color.white.opacity(0.055),
            settingsDetailSurface: Color.white.opacity(0.035),
            settingsCardSurface: Color.white.opacity(0.045),
            settingsCardBorder: Color.white.opacity(0.11),
            previewSurface: Color.primary.opacity(0.055),
            previewSidebarSurface: Color.primary.opacity(0.10),
            primaryText: .white,
            secondaryText: Color.white.opacity(0.72),
            accent: .accentColor,
            controlCornerRadius: 18,
            settingsCornerRadius: 24,
            sectionCornerRadius: 18,
            controlFontDesign: .rounded,
            usesPixelGrid: false,
            usesGlassMaterial: true
        ),
        interaction: ExperienceThemeInteractionTokens(
            approve: ConfirmationActionAppearance(
                foreground: .white,
                background: Color(red: 0.12, green: 0.52, blue: 0.30),
                border: Color(red: 0.39, green: 0.86, blue: 0.56)
            ),
            scopedApproval: ConfirmationActionAppearance(
                foreground: .white,
                background: Color(red: 0.13, green: 0.36, blue: 0.74),
                border: Color(red: 0.43, green: 0.67, blue: 1.00)
            ),
            deny: ConfirmationActionAppearance(
                foreground: .white,
                background: Color(red: 0.67, green: 0.20, blue: 0.24),
                border: Color(red: 1.00, green: 0.49, blue: 0.51)
            ),
            neutral: ConfirmationActionAppearance(
                foreground: .white,
                background: Color.white.opacity(0.12),
                border: Color.white.opacity(0.24)
            )
        ),
        motion: ExperienceThemeMotionTokens(
            controlPressScale: 0.98,
            controlPressDuration: 0.12,
            panelResponse: 0.42,
            panelDampingFraction: 0.8
        ),
        sound: ExperienceThemeSoundProfile(
            recommendedMode: .builtIn,
            auxiliaryCues: [
                .clientStarted: ExperienceThemeSoundCue(
                    systemSound: .hero,
                    island8BitSound: .powerUp,
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
