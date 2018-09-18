import Foundation

public protocol INotificationService {

	func subscribe<Subscriber: AnyObject, Message>(
		_ subscriber: Subscriber,
		to messageType: Message.Type,
		handler: @escaping (Subscriber, Message) -> Void)

	func broadcast<TMessage>(_ message: TMessage)
}
