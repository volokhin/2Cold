import UIKit

open class ViewControllerBase<TViewModel: ViewControllerViewModelBase> : UIViewController, IHaveViewModel {

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

	public init() {
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.viewModel?.willAppear()
	}

	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.viewModel?.didAppear()
	}

	open override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.viewModel?.willDisappear()
	}

	open override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		self.viewModel?.didDisappear()
	}

	open override func viewDidLoad() {
		super.viewDidLoad()

		var view = self.view as? IHaveViewModel
		view?.viewModelObject = self.viewModel
		self.viewModel?.didLoad()
	}

	open func viewModelChanged() {
		self.title = self.viewModel?.title
		self.viewModel?.titleChanged = {
			[weak self] viewModel in
			self?.title = viewModel.title
		}

		if self.isViewLoaded {
			var view = self.view as? IHaveViewModel
			view?.viewModelObject = self.viewModel
		}
	}
}
