import Foundation

public protocol ICellTemplateSelector {
	func template(for vm: Any) -> AnyCellTemplate?
}
