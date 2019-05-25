import Foundation
import SlowCommon

public protocol IDataSource {
	var count: Int { get }
	var reloaded: Event<Void> { get }
	func item(at index: Int) -> Any?
}
