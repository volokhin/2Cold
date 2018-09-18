import Foundation

public protocol ILog {
	func info(_ message: String)
	func warning(_ message: String)
	func error(_ message: String)
}
