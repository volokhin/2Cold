import XCTest
import SlowCommon

private class EventHolder {
	let event: Event<Void> = Event()
}

private class EventSubscriber {
	var invocationsCount: Int = 0
	init(_ eventHolder: EventHolder) {
		eventHolder.event.subscribe(self) {
			this in
			this.invocationsCount = this.invocationsCount + 1
		}
	}
}

class EventTests: XCTestCase {

	private var eventHolder: EventHolder!

	override func setUp() {
		self.eventHolder = EventHolder()
	}

	func test_event_do_not_fire_on_subscribe() {
		let subscriber = EventSubscriber(self.eventHolder)
		XCTAssert(subscriber.invocationsCount == 0)
	}

	func test_event_fire_on_rise() {
		let subscriber = EventSubscriber(self.eventHolder)
		self.eventHolder.event.raise()
		XCTAssert(subscriber.invocationsCount == 1)
	}

	func test_event_fire_twice_on_double_rise() {
		let subscriber = EventSubscriber(self.eventHolder)
		self.eventHolder.event.raise()
		self.eventHolder.event.raise()
		XCTAssert(subscriber.invocationsCount == 2)
	}

	func test_event_fire_once_on_subscribe_twice() {
		var invocationsCount: Int = 0
		self.eventHolder.event.subscribe(self) {
			_ in
			invocationsCount = invocationsCount + 1
		}
		self.eventHolder.event.subscribe(self) {
			_ in
			invocationsCount = invocationsCount + 1
		}
		self.eventHolder.event.raise()
		XCTAssert(invocationsCount == 1)
	}

	func test_event_do_not_retain_subscriber() {
		var dead: EventSubscriber? = EventSubscriber(self.eventHolder)
		let weak = Weak(dead)
		dead = nil
		XCTAssert(weak.isAlive == false)
	}

	func test_event_do_not_fine_on_dead_subscriber() {
		var invocationsCount: Int = 0
		var dead: EventSubscriber? = EventSubscriber(self.eventHolder)
		self.eventHolder.event.subscribe(dead!) {
			_ in
			invocationsCount = invocationsCount + 1
		}
		dead = nil
		self.eventHolder.event.raise()
		XCTAssert(invocationsCount == 0)
	}

	func test_unsubscribe() {
		var invocationsCount: Int = 0
		self.eventHolder.event.subscribe(self) {
			_ in
			invocationsCount = invocationsCount + 1
		}
		self.eventHolder.event.unsubscribe(self)
		self.eventHolder.event.raise()
		XCTAssert(invocationsCount == 0)
	}

}
