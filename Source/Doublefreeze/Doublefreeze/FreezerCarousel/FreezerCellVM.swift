import Foundation
import SlowMVVM

class FreezerCellVM : CellViewModelBase {

	private let notificationService: INotificationService
	private let freezersService: IFreezersService
	private var updating: Bool = false

	let uniqueId: FreezerIdentifier
	let id: Int
	var place: String
	var name: String

	var isEnabled: Bool {
		didSet {
			if oldValue != self.isEnabled {
				self.changeEnabledState()
			}
		}
	}

	init(model: FreezerModel,
		 notificationService: INotificationService,
		 freezersService: IFreezersService) {

		self.notificationService = notificationService
		self.freezersService = freezersService
		self.id = model.id
		self.isEnabled = model.isEnabled
		self.place = model.place
		self.name = model.name
		self.uniqueId = model.uniqueId
	}

	func update(with model: FreezerModel) {
		self.updating = true
		self.isEnabled = model.isEnabled
		self.place = model.place
		self.name = model.name
		self.updating = false
		self.viewModelChanged.raise()
	}

	private func changeEnabledState() {
		guard !self.updating else { return }
		let message = EnabledChangedNotification(freezerId: self.uniqueId, isEnabled: self.isEnabled)
		self.notificationService.broadcast(message)

		if self.isEnabled {
			self.freezersService.enable(freezer: self.uniqueId)
		} else {
			self.freezersService.disable(freezer: self.uniqueId)
		}
	}

}
