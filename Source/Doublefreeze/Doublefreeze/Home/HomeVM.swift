import Foundation
import SlowMVVM

class HomeVM : ViewControllerViewModelBase {

	private let freezersService: IFreezersService

	let listVM: FreezersListVM
	let carouselVM: FreezerCarouselVM

	init(freezersService: IFreezersService,
		 listVM: FreezersListVM,
		 carouselVM: FreezerCarouselVM) {

		self.listVM = listVM
		self.carouselVM = carouselVM
		self.freezersService = freezersService
	}

	override func applicationDidBecomeActive() {
		super.applicationDidBecomeActive()
		self.freezersService.updateAsync()
	}

}
