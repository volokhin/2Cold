import Foundation

public class NotificationService : INotificationService {

	private var subscribers: [AnyHashable: [ISubscriberEntry]] = [:]

	public init() {
		
	}

	public func subscribe<Subscriber: AnyObject, Message>(
		_ subscriber: Subscriber,
		to messageType: Message.Type,
		handler: @escaping (Subscriber, Message) -> Void) {

		let key = ObjectIdentifier(messageType)
		let entry = SubscriberEntry(subscriber: subscriber) {
			[weak subscriber] (message: Message) in
			guard let subscriber = subscriber else { return }
			handler(subscriber, message)
		}

		if var subscribers = self.subscribers[key] {
			subscribers.append(entry)
			self.subscribers[key] = subscribers
		} else {
			self.subscribers[key] = [entry]
		}
	}

	public func unsubscribe<Subscriber: AnyObject, Message>(
		_ subscriber: Subscriber,
		from messageType: Message.Type) {

		let key = ObjectIdentifier(Message.self)
		var subscribers = self.subscribers[key]
		subscribers = subscribers?.filter { !$0.isSupport(messageType) }
		self.subscribers[key] = subscribers
	}

	public func broadcast<Message>(_ message: Message) {
		let key = ObjectIdentifier(Message.self)
		if var subscribers = self.subscribers[key] {
			subscribers = subscribers.filter { $0.isAlive }
			subscribers.forEach { $0.notify(message) }
			self.subscribers[key] = subscribers
		}
	}

}
