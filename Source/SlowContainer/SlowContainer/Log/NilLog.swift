import Foundation

public class NilLog : ILog {
	public func info(_ message: String) { }
	public func warning(_ message: String) { }
	public func error(_ message: String) { }
}
