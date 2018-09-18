import UIKit

class TogleIcon : UIView {

	override var intrinsicContentSize: CGSize {
		return CGSize(width: 40, height: 40)
	}

	private lazy var circleView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 7
		view.backgroundColor = .orangeyRed
		return view
	}()

	private lazy var strokeView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 11
		view.backgroundColor = .white
		return view
	}()

	var isSelected: Bool = false {
		didSet {
			if oldValue != self.isSelected {
				self.updateState(isSelected: self.isSelected, animated: true)
			}
		}
	}

	private var views: [UIView] = []
	private var currentAnimator: UIViewPropertyAnimator? = nil

	override init(frame: CGRect) {
		super.init(frame: frame)

		for _ in 0...3 {
			let view = UIView()
			self.addSubview(view)
			self.views.append(view)
			view.activate(
				view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
				view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
				view.widthAnchor.constraint(equalToConstant: 4),
				view.heightAnchor.constraint(equalToConstant: 40)
			)
		}

		self.addSubview(self.strokeView)
		self.strokeView.activate(
			self.strokeView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			self.strokeView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			self.strokeView.widthAnchor.constraint(equalToConstant: 22),
			self.strokeView.heightAnchor.constraint(equalToConstant: 22)
		)

		self.addSubview(self.circleView)
		self.circleView.activate(
			self.circleView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			self.circleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			self.circleView.widthAnchor.constraint(equalToConstant: 14),
			self.circleView.heightAnchor.constraint(equalToConstant: 14)
		)

		self.updateState(isSelected: self.isSelected, animated: false)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	func setState(isSelected: Bool, animated: Bool) {
		self.updateState(isSelected: isSelected, animated: animated)
		self.isSelected = isSelected
	}

	private func updateState(isSelected: Bool, animated: Bool) {
		self.mutate(isSelected: isSelected, animated: animated)
		self.rotate(isSelected: isSelected, animated: animated)
	}

	private func mutate(isSelected: Bool, animated: Bool) {
		if let currentAnimator = self.currentAnimator {
			currentAnimator.stopAnimation(true)
		}
		let timing = UISpringTimingParameters(damping: 1, response: 0.3)
		let animator = UIViewPropertyAnimator(duration: 0.4, timingParameters: timing)
		let scale: CGFloat = isSelected ? 0.001 : 1.0
		let color: UIColor = isSelected ? .darkSkyBlue : .orangeyRed
		animator.addAnimations {
			for item in self.views.enumerated() {
				item.element.backgroundColor = color
				let angle = isSelected
					? CGFloat.pi / 3 * CGFloat(item.offset)
					: CGFloat.pi / 4 * CGFloat(item.offset)
				item.element.transform = CGAffineTransform(rotationAngle: angle)
			}
			self.circleView.backgroundColor = color
			self.circleView.transform = CGAffineTransform(scaleX: scale, y: scale)
			self.strokeView.transform = CGAffineTransform(scaleX: scale, y: scale)
		}
		self.currentAnimator = animator
		animator.startAnimation()

		if !animated {
			animator.stopAnimation(false)
			animator.finishAnimation(at: .end)
		}
	}

	private func rotate(isSelected: Bool, animated: Bool) {
		let timing = UISpringTimingParameters(damping: 1, response: 0.5)
		let animator = UIViewPropertyAnimator(duration: 0.4, timingParameters: timing)
		animator.addAnimations {
			self.transform = CGAffineTransform(rotationAngle: isSelected ? CGFloat.pi / 2 + CGFloat.pi / 6 : 0)
		}
		animator.startAnimation()

		if !animated {
			animator.stopAnimation(false)
			animator.finishAnimation(at: .end)
		}
	}

}

