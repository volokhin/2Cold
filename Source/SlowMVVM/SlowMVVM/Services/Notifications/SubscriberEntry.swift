import Foundation
import SlowCommon

class SubscriberEntry<Message> : ISubscriberEntry {

	private let subscriber: Weak<AnyObject>
	private let handler: (Message) -> Void

	var isAlive: Bool {
		return self.subscriber.isAlive
	}

	init(subscriber: AnyObject, handler: @escaping (Message) -> Void) {
		self.subscriber = Weak(subscriber)
		self.handler = handler
	}

	func isSupport(_ messageType: Any.Type) -> Bool {
		return messageType == Message.self
	}

	func notify(_ parameter: Any) {
		if let parameter = parameter as? Message {
			self.handler(parameter)
		}
	}
}
