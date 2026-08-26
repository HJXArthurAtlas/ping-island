import XCTest
@testable import Ping_Island

final class ExperienceThemeTests: XCTestCase {
    func testExperienceThemesExposeStableIDsAndRecommendedSoundModes() {
        XCTAssertEqual(ExperienceThemeID.allCases, [.standard, .pixel])
        XCTAssertEqual(ExperienceThemeID.standard.recommendedSoundThemeMode, .builtIn)
        XCTAssertEqual(ExperienceThemeID.pixel.recommendedSoundThemeMode, .island8Bit)
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
}
