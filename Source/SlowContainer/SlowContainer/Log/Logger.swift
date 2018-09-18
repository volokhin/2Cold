import Foundation

internal class Logger {

	private static var log: ILog = NilLog()

	internal static func initialize(log: ILog?) {
		Logger.log = log ?? NilLog()
	}

	internal static func info(_ message: String) {
		Logger.log.info(message)
	}

	internal static func warning(_ message: String) {
		Logger.log.warning(message)
	}

	internal static func error(_ message: String) {
		Logger.log.error(message)
	}
}
