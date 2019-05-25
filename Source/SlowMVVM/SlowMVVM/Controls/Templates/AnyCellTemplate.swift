import Foundation

public struct AnyCellTemplate : ICellTemplate {

	private let template: ICellTemplate
	private let hash: () -> Int
	private let equal: (AnyCellTemplate) -> Bool

	public var reuseIdentifier: String {
		return self.template.reuseIdentifier
	}

	public init<T>(_ template: T) where T: ICellTemplate, T: Hashable {
		self.template = template
		self.hash = { template.hashValue }
		self.equal = {
			(other: AnyCellTemplate) in
			if let other = other.template as? T {
				return other == template
			} else {
				return false
			}
		}
	}

	public func register(in tableView: UITableView) {
		self.template.register(in: tableView)
	}

	public func register(in collectionView: UICollectionView) {
		self.template.register(in: collectionView)
	}
}

extension AnyCellTemplate : Hashable {

	public static func == (lhs: AnyCellTemplate, rhs: AnyCellTemplate) -> Bool {
		return lhs.equal(rhs)
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.hash())
	}
}
