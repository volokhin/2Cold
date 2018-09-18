import Foundation
import SlowMVVM

class FreezerListItemVM : CellViewModelBase {

	private let notificationService: INotificationService

	let uniqueId: FreezerIdentifier
	let id: Int
	var place: String
	var name: String

	var isEnabled: Bool = false {
		didSet {
			if oldValue != self.isEnabled {
				self.viewModelChanged.raise()
			}
		}
	}

	var isSelected: Bool = false {
		didSet {
			if oldValue != self.isSelected {
				self.viewModelChanged.raise()
			}
		}
	}

	init(item: FreezerModel, notificationService: INotificationService) {
		self.notificationService = notificationService
		self.id = item.id
		self.isEnabled = item.isEnabled
		self.place = item.place
		self.name = item.name
		self.uniqueId = item.uniqueId
	}

	func update(with model: FreezerModel) {
		self.isEnabled = model.isEnabled
		self.place = model.place
		self.name = model.name
		self.viewModelChanged.raise()
	}

	override func didSelect() {
		super.didSelect()
		self.notificationService.broadcast(SelectedFreezerChangedNotification(freezerId: self.uniqueId))
		self.notificationService.broadcast(ShowCarouselNotification())
	}

}
