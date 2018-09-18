import Foundation

public class ConsoleLog : ILog {

	public init() {
		
	}

	public func info(_ message: String) {
		print("MVVMSwift INFO: \(message)")
	}

	public func warning(_ message: String) {
		print("MVVMSwift WARNING: \(message)")
	}

	public func error(_ message: String) {
		print("MVVMSwift ERROR: \(message)")
	}
}
