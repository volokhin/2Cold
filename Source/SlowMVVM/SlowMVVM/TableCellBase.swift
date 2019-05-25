import UIKit

open class TableCellBase<TViewModel: CellViewModelBase> : UITableViewCell, IHaveViewModel {

	public var viewModelObject: ViewModelBase? {
		didSet {
			if oldValue !== viewModelObject {
				oldValue?.viewModelChanged.unsubscribe(self)
				self.viewModelChanged()
			}
		}
	}

	public var viewModel: TViewModel? {
		get { return self.viewModelObject as? TViewModel }
		set { self.viewModelObject = newValue }
	}

	open func viewModelChanged() {
		guard let vm = self.viewModel else { return }
		vm.viewModelChanged.subscribe(self) {
			$0.viewModelChanged()
		}
	}
}
