import UIKit
import SlowMVVM

class FreezerCell : CollectionCellBase<FreezerCellVM> {

	@IBOutlet private weak var roomLabel: UILabel!
	@IBOutlet private weak var nameLabel: UILabel!

	override func viewModelChanged() {
		super.viewModelChanged()

		guard let vm = self.viewModel else { return }
		self.nameLabel.text = vm.name
		self.roomLabel.text = vm.place
	}

}
