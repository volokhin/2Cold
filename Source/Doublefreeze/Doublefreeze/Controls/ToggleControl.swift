import UIKit

class ToggleControl : UIControl {

	var isSelectedChanged: (() -> Void)?

	override var intrinsicContentSize: CGSize {
		return CGSize(width: 197, height: 106)
	}

	private lazy var backgroundView: UIView = {
		let view = UIView()
		view.alpha = 0.4
		view.backgroundColor = .black
		view.isUserInteractionEnabled = false
		return view
	}()

	private lazy var innerView: UIView = {
		let view = UIView()
		view.backgroundColor = .orangeyRed
		view.isUserInteractionEnabled = false
		return view
	}()

	private lazy var circleView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 41
		view.backgroundColor = .white
		view.isUserInteractionEnabled = false
		view.layer.masksToBounds = false
		view.layer.shadowColor = UIColor.black.cgColor
		view.layer.shadowOffset = CGSize(width: 0, height: 3)
		view.layer.shadowRadius = 4
		view.layer.shadowOpacity = 1
		return view
	}()

	private lazy var onLabel: UILabel = {
		let label = UILabel()
		label.text = "ON"
		label.font = .toggleButtonFont
		label.textColor = .white
		return label
	}()

	private lazy var offLabel: UILabel = {
		let label = UILabel()
		label.text = "OFF"
		label.font = .toggleButtonFont
		label.textColor = .white
		return label
	}()

	private lazy var togleIcon: TogleIcon = {
		let icon = TogleIcon()
		return icon
	}()

	private lazy var selectionFeedbackGenerator: UISelectionFeedbackGenerator = {
		return UISelectionFeedbackGenerator()
	}()

	override var isHighlighted: Bool {
		didSet {

		}
	}

	override var isSelected: Bool {
		didSet {
			if oldValue != self.isSelected {
				self.updateState(isSelected: self.isSelected, animated: true)
				self.isSelectedChanged?()
			}
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		self.backgroundColor = .clear
		self.addSubview(self.backgroundView)
		self.addSubview(self.innerView)
		self.addSubview(self.circleView)
		self.innerView.addSubview(self.onLabel)
		self.innerView.addSubview(self.offLabel)
		self.circleView.addSubview(self.togleIcon)

		self.isEnabled = true
		self.isUserInteractionEnabled = true

		self.circleView.activate(
			self.circleView.widthAnchor.constraint(equalToConstant: 82),
			self.circleView.heightAnchor.constraint(equalToConstant: 82),
			self.circleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			self.circleView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
		)

		self.onLabel.activate(
			self.onLabel.leadingAnchor.constraint(equalTo: self.innerView.leadingAnchor, constant: 32),
			self.onLabel.centerYAnchor.constraint(equalTo: self.innerView.centerYAnchor)
		)

		self.offLabel.activate(
			self.offLabel.leadingAnchor.constraint(equalTo: self.innerView.leadingAnchor, constant: 96),
			self.offLabel.centerYAnchor.constraint(equalTo: self.innerView.centerYAnchor)
		)

		self.togleIcon.activate(
			self.togleIcon.centerXAnchor.constraint(equalTo: self.circleView.centerXAnchor),
			self.togleIcon.centerYAnchor.constraint(equalTo: self.circleView.centerYAnchor)
		)

//		self.addTarget(self, action: #selector(self.touchDown), for: .touchDown)
//		self.addTarget(self, action: #selector(self.touchUpInside), for: .touchUpInside)
//		self.addTarget(self, action: #selector(self.touchCancel), for: .touchUpOutside)

		let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan))
		self.addGestureRecognizer(pan)

		let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap))
		self.addGestureRecognizer(tap)

//		let tapRecognizer = UITapGestureRecognizer(target: self, action: <#T##Selector?#>)
//		tapRecognizer.delegate

	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	func setState(isSelected: Bool, animated: Bool) {
		self.updateState(isSelected: isSelected, animated: animated)
		self.isSelected = isSelected
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		self.backgroundView.frame = self.bounds
		self.backgroundView.layer.cornerRadius = self.backgroundView.bounds.height / 2

		self.innerView.frame = self.bounds.insetBy(dx: 16, dy: 13)
		self.innerView.layer.cornerRadius = self.innerView.bounds.height / 2
	}

	private func updateState(isSelected: Bool, animated: Bool) {
		self.togleIcon.setState(isSelected: isSelected, animated: animated)

		let timing = UISpringTimingParameters(damping: 1, response: 0.3)
		let animator = UIViewPropertyAnimator(duration: 0.4, timingParameters: timing)
		let offset = self.bounds.width - self.circleView.bounds.width - 32
		animator.addAnimations {
			self.circleView.transform = CGAffineTransform(translationX: isSelected ? offset : 0, y: 0)
			self.innerView.backgroundColor = isSelected ? .darkSkyBlue : .orangeyRed
		}
		animator.startAnimation()

		if !animated {
			animator.stopAnimation(false)
			animator.finishAnimation(at: .end)
		}
	}

	@objc private func touchDown() {
		//print("touchDown")
	}

	@objc private func touchUpInside() {
		//print("touchUpInside")
	}

	@objc private func touchCancel() {
		//print("touchCancel")
	}

	@objc private func pan(recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case .began:
//			let point = recognizer.translation(in: self)
//			if abs(point.x) > abs(point.y) {
//				self.isSelected = point.x > 0
//			}
			break
		case .cancelled:
			//print("cancelled")
			break
		case .changed:
			let point = recognizer.translation(in: self)
			if abs(point.x) > abs(point.y) {
				let isSelected = point.x > 0
				self.generateHapticsFeedback(for: isSelected)
				self.isSelected = isSelected
			}
		case .ended:
			//print("ended")
			break
		case .failed:
			//print("failed")
			break
		case .possible:
			//print("possible")
			break
		@unknown default:
			fatalError()
		}
	}

	@objc private func tap(recognizer: UITapGestureRecognizer) {
		self.generateHapticsFeedback(for: !self.isSelected)
		self.isSelected = !self.isSelected


//		switch recognizer.state {
//		case .began:
//			print("began")
//		case .cancelled:
//			print("cancelled")
//		case .changed:
//			print("changed")
//		case .ended:
//			print("ended")
//		case .failed:
//			print("failed")
//		case .possible:
//			print("possible")
//		@unknown default:
//			fatalError()
//		}
	}

	private func generateHapticsFeedback(for value: Bool) {
		if self.isSelected != value {
			self.selectionFeedbackGenerator.selectionChanged()
		}
	}
}
