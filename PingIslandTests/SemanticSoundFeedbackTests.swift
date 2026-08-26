import XCTest
@testable import Ping_Island

final class SemanticSoundFeedbackTests: XCTestCase {
    func testLifecycleFeedbackKeepsExistingNotificationConfiguration() {
        XCTAssertEqual(AppSoundFeedbackEvent.processingStarted.notificationEvent, .processingStarted)
        XCTAssertEqual(AppSoundFeedbackEvent.attentionRequired.notificationEvent, .attentionRequired)
        XCTAssertEqual(AppSoundFeedbackEvent.taskCompleted.notificationEvent, .taskCompleted)
        XCTAssertEqual(AppSoundFeedbackEvent.taskError.notificationEvent, .taskError)
        XCTAssertEqual(AppSoundFeedbackEvent.resourceLimit.notificationEvent, .resourceLimit)
    }

    func testAuxiliaryFeedbackUsesCompatibleSoundPackFallbacks() {
        XCTAssertNil(AppSoundFeedbackEvent.approvalAccepted.notificationEvent)
        XCTAssertEqual(AppSoundFeedbackEvent.approvalAccepted.soundPackFallbackEvent, .attentionRequired)
        XCTAssertEqual(AppSoundFeedbackEvent.approvalScoped.soundPackFallbackEvent, .attentionRequired)
        XCTAssertEqual(AppSoundFeedbackEvent.approvalRejected.soundPackFallbackEvent, .taskError)
        XCTAssertEqual(AppSoundFeedbackEvent.clientStarted.island8BitSound, .powerUp)
        XCTAssertEqual(AppSoundFeedbackEvent.islandDetached.island8BitSound, .bubblePop)
    }
}
