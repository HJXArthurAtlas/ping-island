import Foundation

/// Domain events used by the UI and session lifecycle. Callers describe what
/// happened; the selected experience and sound mode decide how it sounds.
enum AppSoundFeedbackEvent: CaseIterable, Identifiable, Equatable {
    case clientStarted
    case islandDetached
    case processingStarted
    case attentionRequired
    case approvalAccepted
    case approvalScoped
    case approvalRejected
    case taskCompleted
    case taskError
    case resourceLimit

    var id: String { String(describing: self) }

    var notificationEvent: NotificationEvent? {
        switch self {
        case .processingStarted:
            return .processingStarted
        case .attentionRequired:
            return .attentionRequired
        case .taskCompleted:
            return .taskCompleted
        case .taskError:
            return .taskError
        case .resourceLimit:
            return .resourceLimit
        case .clientStarted, .islandDetached, .approvalAccepted, .approvalScoped, .approvalRejected:
            return nil
        }
    }

    /// CESP v1 does not define dedicated approval or window-presentation
    /// categories. These fallbacks retain imported-pack support until the
    /// format gains matching semantic categories.
    var soundPackFallbackEvent: NotificationEvent {
        switch self {
        case .clientStarted, .islandDetached, .processingStarted:
            return .processingStarted
        case .attentionRequired, .approvalAccepted, .approvalScoped:
            return .attentionRequired
        case .approvalRejected, .taskError:
            return .taskError
        case .taskCompleted:
            return .taskCompleted
        case .resourceLimit:
            return .resourceLimit
        }
    }

    var builtInFallbackSound: NotificationSound {
        switch self {
        case .clientStarted:
            return .hero
        case .islandDetached:
            return .pop
        case .processingStarted:
            return .tink
        case .attentionRequired:
            return .glass
        case .approvalAccepted:
            return .ping
        case .approvalScoped:
            return .glass
        case .approvalRejected, .taskError:
            return .basso
        case .taskCompleted:
            return .blow
        case .resourceLimit:
            return .morse
        }
    }

    var island8BitSound: Island8BitSound {
        switch self {
        case .clientStarted:
            return .powerUp
        case .islandDetached:
            return .bubblePop
        case .processingStarted:
            return .menuSelect
        case .attentionRequired:
            return .approvalAlert
        case .approvalAccepted:
            return .itemPickup
        case .approvalScoped:
            return .menuSelect
        case .approvalRejected, .taskError:
            return .hurt
        case .taskCompleted:
            return .submitBlip
        case .resourceLimit:
            return .completeDing
        }
    }
}

extension NotificationEvent {
    var soundFeedbackEvent: AppSoundFeedbackEvent {
        switch self {
        case .processingStarted:
            return .processingStarted
        case .attentionRequired:
            return .attentionRequired
        case .taskCompleted:
            return .taskCompleted
        case .taskError:
            return .taskError
        case .resourceLimit:
            return .resourceLimit
        }
    }
}

@MainActor
enum AppSoundFeedback {
    static func play(_ event: AppSoundFeedbackEvent) {
        guard AppSettings.soundEnabled else { return }
        guard !AppSettings.areReminderNotificationsSuppressed else { return }

        if let notificationEvent = event.notificationEvent {
            AppSettings.playSound(for: notificationEvent)
            return
        }

        AppSettings.playAuxiliarySound(
            systemSound: event.builtInFallbackSound,
            island8BitSound: event.island8BitSound,
            soundPackFallback: event.soundPackFallbackEvent
        )
    }
}
