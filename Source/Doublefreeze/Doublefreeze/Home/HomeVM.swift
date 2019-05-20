import Foundation
import SlowMVVM

class HomeVM : ViewControllerViewModelBase {

	private let freezersService: IFreezersService
	private let setting: IUserSettings

	let listVM: FreezersListVM
	let carouselVM: FreezerCarouselVM

	init(freezersService: IFreezersService,
		 setting: IUserSettings,
		 listVM: FreezersListVM,
		 carouselVM: FreezerCarouselVM) {

		self.listVM = listVM
		self.carouselVM = carouselVM
		self.freezersService = freezersService
		self.setting = setting
	}

	override func applicationDidBecomeActive() {
		super.applicationDidBecomeActive()
		self.freezersService.updateAsync()
	}

	override func applicationWillResignActive() {
		super.applicationWillResignActive()
		self.setting.flush()
	}
}
