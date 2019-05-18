import Foundation
import SlowMVVM

class FreezersListVM : ViewControllerViewModelBase {

	private var settings: IUserSettings
	private let freezersService: IFreezersService
	private let notificationService: INotificationService
	private var itemsMap: [FreezerIdentifier: FreezerListItemVM] = [:]
	
	var items: [FreezerListItemVM] = []
	var onReload: (() -> Void)?

	var selectedFloorIndex: Int = 0 {
		didSet {
			if oldValue != self.selectedFloorIndex {
				self.changeFloor()
			}
		}
	}

	private var selectedFloor: Int {
		return self.selectedFloorIndex == 0 ? 5 : 8
	}

	lazy var openCarouselCommand: Command<Void> = {
		return Command(self) {
			$0.notificationService.broadcast(ShowCarouselNotification())
		}
	}()

	lazy var changeFloorCommand: Command<Int> = {
		return Command(self) {
			this, index in
			this.selectedFloorIndex = index
		}
	}()

	init(freezersService: IFreezersService,
		 notificationService: INotificationService,
		 settings: IUserSettings) {

		self.settings = settings
		self.freezersService = freezersService
		self.notificationService = notificationService

		super.init()

		self.selectedFloorIndex = settings.floor == 8 ? 1 : 0
		
		self.createItems()

		self.notificationService.subscribe(self, to: SelectedFreezerChangedNotification.self) {
			this, i in
			this.updateCurrentFreezer(i.freezerId)
		}

		self.notificationService.subscribe(self, to: EnabledChangedNotification.self) {
			this, i in
			this.itemsMap[i.freezerId]?.isEnabled = i.isEnabled
		}

		self.freezersService.updated.subscribe(self) {
			this, freezers in
			this.updateItems(freezers: freezers)
		}
	}

	private func changeFloor() {
		self.settings.floor = self.selectedFloor
		self.createItems()
		self.onReload?()
		self.notificationService.broadcast(FloorChangedNotification(floor: self.selectedFloor))
	}

	private func createItems() {
		let freezers = self.freezersService.freezers()
		self.items = freezers
			.filter { $0.floor == self.selectedFloor }
			.sorted { $0.place == $1.place ? $0.name < $1.name : $0.place < $1.place }
			.map { FreezerListItemVM(item: $0, notificationService: self.notificationService) }
		self.itemsMap = Dictionary(uniqueKeysWithValues: self.items.map { ($0.uniqueId, $0) })
	}

	private func updateItems(freezers: [FreezerModel]) {
		for item in freezers {
			if let vm = itemsMap[item.uniqueId] {
				vm.update(with: item)
			}
		}
	}

	private func updateCurrentFreezer(_ freezerId: FreezerIdentifier) {
		for item in self.items {
			item.isSelected = item.uniqueId == freezerId
		}
	}

}
