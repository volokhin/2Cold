import Foundation
import SlowCommon

public final class BindableCollection<Element> {

	public typealias Element = Element
	public typealias Index = Int
	public typealias Iterator = IndexingIterator<[Element]>

	public let reloaded: Event<Void> = Event()

	private var storage: [Element] = []

	public init() {

	}

	public init(items: [Element]) {
		self.storage = items
	}

}

extension BindableCollection : IDataSource {

	public func item(at index: Int) -> Any? {
		if index >= 0 && index < self.count {
			return self.storage[index]
		} else {
			return nil
		}
	}

}

extension BindableCollection : RandomAccessCollection {

	public var startIndex: Int {
		return self.storage.startIndex
	}

	public var endIndex: Int {
		return self.storage.endIndex
	}

	public func makeIterator() -> IndexingIterator<[Element]> {
		return self.storage.makeIterator()
	}

	public func index(after i: Int) -> Int {
		return self.storage.index(after: i)
	}

	public subscript(position: Int) -> Element {
		return self.storage[position]
	}
}

public extension BindableCollection {

	func reload(with storage: [Element]) {
		self.storage = storage
		self.reloaded.raise()
	}
}

extension BindableCollection : ExpressibleByArrayLiteral {
	public typealias ArrayLiteralElement = Element

	public convenience init(arrayLiteral elements: Element...) {
		self.init(items: elements)
	}
}
