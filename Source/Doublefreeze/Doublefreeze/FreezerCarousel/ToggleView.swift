import UIKit
import SlowMVVM

class ToggleView : ViewBase<FreezerCellVM> {

	private lazy var toggleControl: ToggleControl = {
		let control = ToggleControl(frame: .zero)
		control.isSelectedChanged = {
			[weak self] in
			self?.viewModel?.isEnabled = self?.toggleControl.isSelected ?? false
		}
		return control
	}()

	override var intrinsicContentSize: CGSize {
		return self.toggleControl.intrinsicContentSize
	}

	required init() {
		super.init()
		self.addSubview(self.toggleControl)

		self.toggleControl.activate(
			self.toggleControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			self.toggleControl.centerYAnchor.constraint(equalTo: self.centerYAnchor)
		)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	internal override func viewModelChanged() {
		super.viewModelChanged()
		guard let vm = self.viewModel else { return }
		self.toggleControl.setState(isSelected: vm.isEnabled, animated: true)
	}

}
