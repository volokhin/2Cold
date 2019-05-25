import Foundation

public struct CellClassTemplate : ICellTemplate {

	public let reuseIdentifier: String
	private let cellClass: AnyClass

	public init(cellClass: AnyClass, reuseIdentifier: String) {
		self.reuseIdentifier = reuseIdentifier
		self.cellClass = cellClass
	}

	public func register(in tableView: UITableView) {
		tableView.register(self.cellClass, forCellReuseIdentifier: self.reuseIdentifier)
	}

	public func register(in collectionView: UICollectionView) {
		collectionView.register(self.cellClass, forCellWithReuseIdentifier: self.reuseIdentifier)
	}

}

extension CellClassTemplate : Hashable {

	public static func == (lhs: CellClassTemplate, rhs: CellClassTemplate) -> Bool {
		return lhs.reuseIdentifier == rhs.reuseIdentifier
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.reuseIdentifier)
	}
}
