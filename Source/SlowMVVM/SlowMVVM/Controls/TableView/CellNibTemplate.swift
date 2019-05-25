import Foundation

public struct CellNibTemplate : ICellTemplate {

	public let reuseIdentifier: String
	private let nib: UINib

	public init(nib: UINib, reuseIdentifier: String) {
		self.reuseIdentifier = reuseIdentifier
		self.nib = nib
	}

	public func register(in tableView: UITableView) {
		tableView.register(self.nib, forCellReuseIdentifier: self.reuseIdentifier)
	}
}

extension CellNibTemplate : Hashable {

	public static func == (lhs: CellNibTemplate, rhs: CellNibTemplate) -> Bool {
		return lhs.reuseIdentifier == rhs.reuseIdentifier
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.reuseIdentifier)
	}
}
