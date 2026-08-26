import XCTest
@testable import Ping_Island

final class ExperienceSoundTransitionTests: XCTestCase {
    func testUsageWarningOnlyFiresWhenCrossingNinetyPercent() {
        XCTAssertNil(UsageSoundTransitionEvaluator.event(previous: nil, current: 95))
        XCTAssertNil(UsageSoundTransitionEvaluator.event(previous: 91, current: 96))
        XCTAssertEqual(
            UsageSoundTransitionEvaluator.event(previous: 89, current: 90),
            .usageWarning
        )
    }

    func testUsageResetOnlyFiresAfterMeaningfulRecovery() {
        XCTAssertNil(UsageSoundTransitionEvaluator.event(previous: 49, current: 20))
        XCTAssertNil(UsageSoundTransitionEvaluator.event(previous: 80, current: 30))
        XCTAssertEqual(
            UsageSoundTransitionEvaluator.event(previous: 80, current: 20),
            .usageReset
        )
    }

    func testIdleReminderFiresOnceUntilSessionLeavesWaitingState() {
        let now = Date()
        var tracker = IdleReminderSoundTracker()
        var session = SessionState(
            sessionId: "idle-reminder",
            cwd: "/tmp/project",
            phase: .waitingForInput,
            lastActivity: now.addingTimeInterval(-IdleReminderSoundTracker.reminderDelay - 1)
        )

        XCTAssertEqual(tracker.sessionsNeedingReminder(from: [session], now: now).count, 1)
        XCTAssertTrue(tracker.sessionsNeedingReminder(from: [session], now: now).isEmpty)

        session.phase = .processing
        XCTAssertTrue(tracker.sessionsNeedingReminder(from: [session], now: now).isEmpty)
        session.phase = .waitingForInput
        XCTAssertEqual(tracker.sessionsNeedingReminder(from: [session], now: now).count, 1)
    }
}
