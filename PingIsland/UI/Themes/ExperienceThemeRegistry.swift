import Foundation

/// The single registration point for compiled-in themes. Adding a theme is a
/// deliberate product change: add its stable ID, create its own definition
/// file, and register that definition here.
enum ExperienceThemeRegistry {
    static let all: [IslandExperienceTheme] = [
        DefaultExperienceTheme.definition,
        PixelExperienceTheme.definition
    ]

    static func theme(for id: ExperienceThemeID) -> IslandExperienceTheme {
        all.first(where: { $0.id == id }) ?? DefaultExperienceTheme.definition
    }
}
