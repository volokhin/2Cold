import XCTest
import SlowContainer
@testable import SlowMVVM

private class Base {}
private class Derived: Base {}

internal class NotificationServiceTests: XCTestCase {

	private var service: INotificationService!

//	internal override func setUp() {
//		super.setUp()
//		self.service = NotificationService()
//	}
//
//	internal func test_delivers_notification() {
//		var result: Int = 0
//		self.service.subscribe(Int.self) { parameter in
//			result = parameter
//		}
//		self.service.broadcast(42)
//		XCTAssert(result == 42)
//	}
//
//	internal func test_do_not_deliver_unregistered_notification() {
//		var notificationsCount: Int = 0
//		self.service.subscribe(Int.self) { _ in
//			notificationsCount = notificationsCount + 1
//		}
//		self.service.broadcast("string")
//		XCTAssert(notificationsCount == 0)
//	}
//
//	internal func test_delivers_notification_to_all_subscribers() {
//		var notificationsCount: Int = 0
//		self.service.subscribe(String.self) { _ in
//			notificationsCount = notificationsCount + 1
//		}
//		self.service.subscribe(String.self) { _ in
//			notificationsCount = notificationsCount + 1
//		}
//		self.service.broadcast("string")
//		XCTAssert(notificationsCount == 2)
//	}

}
