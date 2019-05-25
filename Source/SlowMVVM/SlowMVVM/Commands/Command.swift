import Foundation
import SlowContainer
import SlowCommon

open class Command<Parameter> {

	public var onExecute: Event<Parameter>

	public init() {
		self.onExecute = Event<Parameter>()
	}

	public convenience init<Subscriber: AnyObject>(
		_ subscriber: Subscriber,
		handler: @escaping (Subscriber, Parameter) -> Void) {

		self.init()
		self.onExecute.subscribe(subscriber, handler: handler)
	}

	func execute(parameter: Parameter) {
		self.onExecute.raise(parameter)
	}
}

public extension Command where Parameter == Void {

	convenience init<Subscriber: AnyObject>(
		_ subscriber: Subscriber,
		handler: @escaping (Subscriber) -> Void) {

		self.init()
		self.onExecute.subscribe(subscriber, handler: handler)
	}
}
