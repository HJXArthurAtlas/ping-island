import Foundation

/// A cohesive presentation profile for Ping Island's visual, interaction, and
/// sound feedback layers. The selected profile is intentionally separate from
/// a user-imported CESP sound pack: a pack may replace audio without changing
/// the visual experience.
enum ExperienceThemeID: String, CaseIterable, Identifiable {
    case standard
    case pixel

    var id: String { rawValue }

    var title: String {
        switch self {
        case .standard:
            return "默认"
        case .pixel:
            return "Pixel"
        }
    }

    var subtitle: String {
        switch self {
        case .standard:
            return "克制、清晰的 macOS 体验，适合长时间使用。"
        case .pixel:
            return "像素化边框、图标与 8-bit 提示反馈，作为完整体验示例。"
        }
    }

    var recommendedSoundThemeMode: SoundThemeMode {
        switch self {
        case .standard:
            return .builtIn
        case .pixel:
            return .island8Bit
        }
    }
}

/// Visual and feedback intent for an action that affects a pending operation.
/// Views use this rather than choosing colors ad hoc.
enum ConfirmationActionRole: String, CaseIterable, Identifiable {
    case approve
    case scopedApproval
    case deny
    case neutral

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .approve:
            return "checkmark"
        case .scopedApproval:
            return "checkmark.circle"
        case .deny:
            return "xmark"
        case .neutral:
            return "arrow.up.right.square"
        }
    }

    var soundFeedbackEvent: AppSoundFeedbackEvent? {
        switch self {
        case .approve:
            return .approvalAccepted
        case .scopedApproval:
            return .approvalScoped
        case .deny:
            return .approvalRejected
        case .neutral:
            return nil
        }
    }
}
