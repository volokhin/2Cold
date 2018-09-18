import Foundation

protocol ISubscriberEntry {
	var isAlive: Bool { get }
	func isSupport(_ messageType: Any.Type) -> Bool
	func notify(_ parameter: Any)
}
