import Foundation

private class Handler<Args> {

	private let subscriber: Weak<AnyObject>
	private let action: (Args) -> Void

	var isAlive: Bool {
		return self.subscriber.isAlive
	}

	init(subscriber: AnyObject, action: @escaping (Args) -> Void) {
		self.subscriber = Weak(value: subscriber)
		self.action = action
	}

	func rise(_ args: Args) {
		self.action(args)
	}
}

public class Event<Args> {
	
	private var handlers: [AnyHashable: Handler<Args>]

	public init() {
		self.handlers = [:]
	}

	public func subscribe<Subscriber: AnyObject>(
		_ subscriber: Subscriber,
		handler: @escaping (Subscriber, Args) -> Void) {

		let key = ObjectIdentifier(subscriber)
		self.handlers[key] = Handler(subscriber: subscriber) {
			[weak subscriber] args in
			guard let subscriber = subscriber else { return }
			handler(subscriber, args)
		}
	}

	public func unsubscribe(_ subscriber: AnyObject) {
		let key = ObjectIdentifier(subscriber)
		self.handlers[key] = nil
	}

	public func raise(_ args: Args) {
		let handlers = self.handlers.filter { $0.value.isAlive }
		handlers.forEach { $0.value.rise(args) }
		self.handlers = handlers
	}
}

public extension Event where Args == Void {

	func subscribe<Subscriber: AnyObject>(
		_ subscriber: Subscriber,
		handler: @escaping (Subscriber) -> Void) {

		self.subscribe(subscriber) {
			this, _ in
			handler(this)
		}
	}

	func raise() {
		self.raise(())
	}

}
