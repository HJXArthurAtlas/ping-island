import XCTest
@testable import Ping_Island

final class ExperienceThemeTests: XCTestCase {
    func testRegistryContainsEveryPersistedBuiltInThemeExactlyOnce() {
        let registeredIDs = ExperienceThemeRegistry.all.map(\.id)

        XCTAssertEqual(Set(registeredIDs), Set(ExperienceThemeID.allCases))
        XCTAssertEqual(registeredIDs.count, Set(registeredIDs).count)
    }

    func testDefaultAndPixelKeepTheirOwnVisualContracts() {
        let standard = ExperienceThemeRegistry.theme(for: .standard)
        let pixel = ExperienceThemeRegistry.theme(for: .pixel)

        XCTAssertEqual(standard.metadata.displayName, "默认")
        XCTAssertFalse(standard.visual.usesPixelGrid)
        XCTAssertTrue(standard.visual.usesGlassMaterial)
        XCTAssertEqual(standard.visual.controlCornerRadius, 18)

        XCTAssertEqual(pixel.metadata.displayName, "Pixel")
        XCTAssertTrue(pixel.visual.usesPixelGrid)
        XCTAssertFalse(pixel.visual.usesGlassMaterial)
        XCTAssertEqual(pixel.visual.controlCornerRadius, 2)
    }

    func testThemeSoundProfilesMatchTheirRecommendedModes() {
        for id in ExperienceThemeID.allCases {
            let theme = ExperienceThemeRegistry.theme(for: id)
            XCTAssertEqual(theme.sound.recommendedMode, id.recommendedSoundThemeMode)
        }

        XCTAssertEqual(
            ExperienceThemeRegistry.theme(for: .pixel).sound.cue(for: .clientStarted)?.island8BitSound,
            .bootJingle
        )
    }

    func testConfirmationActionRolesKeepTheirSemanticsDistinct() {
        XCTAssertEqual(ConfirmationActionRole.approve.systemImage, "checkmark")
        XCTAssertEqual(ConfirmationActionRole.scopedApproval.systemImage, "checkmark.circle")
        XCTAssertEqual(ConfirmationActionRole.deny.systemImage, "xmark")
        XCTAssertEqual(ConfirmationActionRole.neutral.systemImage, "arrow.up.right.square")
        XCTAssertEqual(ConfirmationActionRole.approve.soundFeedbackEvent, .approvalAccepted)
        XCTAssertEqual(ConfirmationActionRole.scopedApproval.soundFeedbackEvent, .approvalScoped)
        XCTAssertEqual(ConfirmationActionRole.deny.soundFeedbackEvent, .approvalRejected)
        XCTAssertNil(ConfirmationActionRole.neutral.soundFeedbackEvent)
    }

    func testEveryThemeSuppliesCuesForAuxiliaryFeedback() {
        let auxiliaryEvents = AppSoundFeedbackEvent.allCases.filter { $0.notificationEvent == nil }

        for theme in ExperienceThemeRegistry.all {
            for event in auxiliaryEvents {
                XCTAssertNotNil(
                    theme.sound.cue(for: event),
                    "\(theme.id.rawValue) must define a cue for \(event.id)"
                )
            }
        }
    }
}
