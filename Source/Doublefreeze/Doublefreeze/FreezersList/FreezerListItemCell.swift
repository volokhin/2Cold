import UIKit
import SlowMVVM

class FreezerListItemCell : TableCellBase<FreezerListItemVM>, ICanMakeFromXib {

	@IBOutlet private weak var selectionView: UIView!
	@IBOutlet private weak var circleView: UIView!
	@IBOutlet private weak var roomNameLabel: UILabel!
	@IBOutlet private weak var freezerNameLabel: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
		self.circleView.layer.cornerRadius = self.circleView.bounds.width / 2
		self.selectionView.layer.cornerRadius = self.selectionView.bounds.width / 2
		self.selectionStyle = .none
		self.separatorInset = UIEdgeInsets(top: 0, left: CGFloat.greatestFiniteMagnitude, bottom: 0, right: 0)
	}

	override func viewModelChanged() {
		super.viewModelChanged()

		guard let vm = self.viewModel else { return }
		self.circleView.backgroundColor = vm.isEnabled ? .darkSkyBlue : .orangeyRed
		self.selectionView.backgroundColor = vm.isEnabled ? .darkSkyBlue : .orangeyRed
		self.selectionView.alpha = vm.isSelected ? 0.5: 0.0
		self.freezerNameLabel.text = vm.name
		self.roomNameLabel.text = vm.place
		self.roomNameLabel.textColor = vm.isSelected ? .charcoal: .brownishGrey
	}

	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		super.setHighlighted(highlighted, animated: animated)

		let timing = UISpringTimingParameters(damping: 1, response: 0.3)
		let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timing)
		let opacity: CGFloat = highlighted ? 0.4 : 1
		animator.addAnimations {
			self.circleView.alpha = opacity
			self.roomNameLabel.alpha = opacity
			self.freezerNameLabel.alpha = opacity
		}
		animator.startAnimation()
	}

}
