import Foundation
@testable import SlowContainer

internal class LogMock : ILog {

	internal var lastInfo: String = ""
	internal var lastWarning: String = ""
	internal var lastError: String = ""

	internal func info(_ message: String) {
		print("MVVMSwift INFO: \(message)")
		self.lastInfo = message
		self.lastWarning = ""
		self.lastError = ""
	}

	internal func warning(_ message: String) {
		print("MVVMSwift WARNING: \(message)")
		self.lastInfo = ""
		self.lastWarning = message
		self.lastError = ""
	}

	internal func error(_ message: String) {
		print("MVVMSwift ERROR: \(message)")
		self.lastInfo = ""
		self.lastWarning = ""
		self.lastError = message
	}
}
