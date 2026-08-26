import Foundation

/// Stable persisted identity for a compiled-in experience theme. Visual tokens
/// and sound cues live with each implementation under `UI/Themes/`.
enum ExperienceThemeID: String, CaseIterable, Identifiable {
    case standard
    case pixel

    var id: String { rawValue }

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
