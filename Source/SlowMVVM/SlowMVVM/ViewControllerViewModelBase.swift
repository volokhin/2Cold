import Foundation

open class ViewControllerViewModelBase : ViewModelBase {

	public var titleChanged: ((ViewControllerViewModelBase) -> Void)?

	public var title: String? {
		didSet {
			if oldValue != title {
				self.titleChanged?(self)
			}
		}
	}

	public override init() {
		super.init()

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.applicationDidBecomeActive),
			name: UIApplication.didBecomeActiveNotification,
			object: nil)

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.applicationWillResignActive),
			name: UIApplication.willResignActiveNotification,
			object: nil)
	}

	open func willAppear() {

	}

	open func willDisappear() {

	}

	open func didAppear() {

	}

	open func didDisappear() {

	}

	open func didLoad() {

	}

	@objc open func applicationDidBecomeActive() {

	}

	@objc open func applicationWillResignActive() {

	}
}
