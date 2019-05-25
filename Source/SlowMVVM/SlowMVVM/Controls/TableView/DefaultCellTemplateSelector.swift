import Foundation

public final class DefaultCellTemplateSelector : ICellTemplateSelector {

	private var cache: [String: AnyCellTemplate] = [:]

	public func template(for vm: Any) -> AnyCellTemplate? {
		var result: AnyCellTemplate? = nil
		let vmTypeString = String(reflecting: type(of: vm))
		result = self.cache[vmTypeString]
		if result == nil, let cellTypeString = self.convertToCellTypeString(vmTypeString) {
			let cellType: AnyClass? = NSClassFromString(cellTypeString)
			if let cellType = cellType {
				if let nibCell = cellType as? ICanMakeFromXib.Type {
					let template = CellNibTemplate(nib: nibCell.nib(), reuseIdentifier: cellTypeString)
					result = AnyCellTemplate(template)
					self.cache[vmTypeString] = result
				} else {
					let template = CellClassTemplate(cellClass: cellType, reuseIdentifier: cellTypeString)
					result = AnyCellTemplate(template)
					self.cache[vmTypeString] = result
				}
			}
		}
		return result
	}

	private func convertToCellTypeString(_ vmType: String) -> String? {
		if vmType.hasSuffix("VM") {
			return vmType.dropLast(2) + "Cell"
		} else {
			return nil
		}
	}

}
