import UIKit

open class ViewBase<TViewModel: ViewModelBase> : UIView, IHaveViewModel {

	public required init() {
		super.init(frame: .zero)
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	public var viewModelObject: ViewModelBase? {
		didSet {
			if oldValue !== viewModelObject {
				oldValue?.viewModelChanged.unsubscribe(self)
				viewModelObject?.viewModelChanged.subscribe(self) {
					$0.viewModelChanged()
				}
				self.viewModelChanged()
			}
		}
	}

	public var viewModel: TViewModel? {
		get { return self.viewModelObject as? TViewModel }
		set { self.viewModelObject = newValue }
	}

	open func viewModelChanged() {

	}
}
