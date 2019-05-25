import Foundation
import SlowMVVM

class FreezerCarouselVM : ViewControllerViewModelBase {

	private var settings: IUserSettings
	private let notificationService: INotificationService
	private let freezersService: IFreezersService
	private var itemsMap: [FreezerIdentifier: FreezerVM] = [:]

	var items: BindableCollection<FreezerVM> = []
	var onReload: (() -> Void)?

	lazy var openListCommand: Command<Void> = {
		return Command(self) {
			$0.notificationService.broadcast(ShowListNotification())
		}
	}()

	var selectedItem: FreezerVM? {
		didSet {
			if oldValue?.uniqueId != self.selectedItem?.uniqueId {
				self.changeSelectedItem()
			}
		}
	}

	private var selectedFloor: Int = 5 {
		didSet {
			if oldValue != self.selectedFloor {
				self.changeFloor()
			}
		}
	}

	init(freezersService: IFreezersService,
		 notificationService: INotificationService,
		 settings: IUserSettings) {

		self.settings = settings
		self.freezersService = freezersService
		self.notificationService = notificationService

		super.init()

		let savedFreezer = settings.freezerId ?? FreezerIdentifier(floor: 5, id: 10)
		self.selectedFloor = savedFreezer.floor

		self.createItems()
		self.selectedItem = self.itemsMap[savedFreezer] ?? (self.items.count > 0 ? self.items[0] : nil)

		self.changeSelectedItem()

		self.notificationService.subscribe(self, to: FloorChangedNotification.self) {
			this, i in
			this.selectedFloor = i.floor
		}

		self.notificationService.subscribe(self, to: SelectedFreezerChangedNotification.self) {
			this, i in
			let item = this.items.first { $0.uniqueId == i.freezerId }
			this.selectedItem = item
		}

		self.notificationService.subscribe(self, to: EnabledChangedNotification.self) {
			this, i in
			this.viewModelChanged.raise()
		}

		self.freezersService.updated.subscribe(self) {
			this, freezers in
			this.updateItems(freezers: freezers)
			this.viewModelChanged.raise()
		}
	}

	private func changeFloor() {
		self.selectedItem = nil
		self.createItems()
		self.onReload?()
		self.selectedItem = self.items.count > 0 ? self.items[0] : nil
	}

	private func changeSelectedItem() {
		guard let item = self.selectedItem else { return }
		self.settings.freezerId = item.uniqueId
		self.notificationService.broadcast(SelectedFreezerChangedNotification(freezerId: item.uniqueId))
		self.viewModelChanged.raise()
	}

	private func createItems() {
		let freezers = self.freezersService.freezers()
		let items = freezers
			.filter { $0.floor == self.selectedFloor }
			.sorted { $0.place == $1.place ? $0.name < $1.name : $0.place < $1.place }
			.map { FreezerVM(model: $0, notificationService: self.notificationService, freezersService: self.freezersService) }
		self.items.reload(with: items)
		self.itemsMap = Dictionary(uniqueKeysWithValues: self.items.map { ($0.uniqueId, $0) })
	}

	private func updateItems(freezers: [FreezerModel]) {
		for item in freezers {
			if let vm = itemsMap[item.uniqueId] {
				vm.update(with: item)
			}
		}
	}

}
