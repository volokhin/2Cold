import UIKit
import SlowMVVM
import SlowHelpers

class HomeVC : ViewControllerBase<HomeVM> {

	private enum State {
		case list
		case carousel
	}

	private var state: State = .list

	private lazy var topContainerView: UIView = {
		return UIView()
	}()

	private lazy var bottomContainerView: UIView = {
		return UIView()
	}()

	private lazy var freezersListVC: FreezersListVC = {
		let vc = FreezersListVC()
		return vc
	}()

	private lazy var freezerCarouselVC: FreezerCarouselVC = {
		let vc = FreezerCarouselVC()
		return vc
	}()

	private var currentOffset: CGFloat = 0

	init(notificationService: INotificationService) {
		super.init()

		notificationService.subscribe(self, to: ShowCarouselNotification.self) {
			this, _ in
			this.updateState(state: .carousel, animated: true)
		}

		notificationService.subscribe(self, to: ShowListNotification.self) {
			this, _ in
			this.updateState(state: .list, animated: true)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.view.addSubview(self.topContainerView)
		self.view.addSubview(self.bottomContainerView)

		self.addChild(self.freezersListVC, to: self.topContainerView)
		self.addChild(self.freezerCarouselVC, to: self.bottomContainerView)

		self.topContainerView.activate(
			self.topContainerView.topAnchor.constraint(equalTo: self.view.topAnchor),
			self.topContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			self.topContainerView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
			self.topContainerView.heightAnchor.constraint(equalTo: self.view.heightAnchor)
		)

		self.bottomContainerView.activate(
			self.bottomContainerView.topAnchor.constraint(equalTo: self.view.bottomAnchor),
			self.bottomContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			self.bottomContainerView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
			self.bottomContainerView.heightAnchor.constraint(equalTo: self.view.heightAnchor)
		)

		let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan))
		self.view.addGestureRecognizer(pan)

		self.updateState(state: .carousel, animated: false)

	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

	}

	override func viewSafeAreaInsetsDidChange() {
		super.viewSafeAreaInsetsDidChange()
	}

	override func viewModelChanged() {
		super.viewModelChanged()
		self.freezersListVC.viewModel = self.viewModel?.listVM
		self.freezerCarouselVC.viewModel = self.viewModel?.carouselVM
	}

	private func updateState(state: State, animated: Bool) {
		self.state = state
		self.freezersListVC.isActive = state == .list
		self.freezerCarouselVC.isActive = state == .carousel
		let offset = self.state == .list ? 0 : -self.view.bounds.height

		let timing = UISpringTimingParameters(dampingRatio: 1, initialVelocity: CGVector(dx: 0, dy: 0))
		let animator = UIViewPropertyAnimator(duration: 0.4, timingParameters: timing)
		animator.addAnimations {
			self.topContainerView.transform = CGAffineTransform(translationX: 0, y: offset)
			self.bottomContainerView.transform = CGAffineTransform(translationX: 0, y: offset)
		}
		animator.startAnimation()

		if !animated {
			animator.stopAnimation(false)
			animator.finishAnimation(at: .end)
		}
	}

	@objc private func pan(recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case .changed:
			let translation = recognizer.translation(in: self.view)
			if (self.state == .carousel && translation.y >= 0) || (self.state == .list && translation.y <= 0) {
				if abs(translation.y) > abs(translation.x) {
					self.translateView(translation)
				}
				self.currentOffset = translation.y
			}
		case .cancelled, .ended, .failed:
			let velocity = recognizer.velocity(in: self.view)
			let translation = recognizer.translation(in: self.view)
			self.stickToState(translation, velocity)
			self.currentOffset = 0
		default:
			self.currentOffset = 0
		}
	}

	private func translateView(_ translation: CGPoint) {
		let offset = translation.y - self.currentOffset
		self.topContainerView.transform = self.topContainerView.transform.translatedBy(x: 0, y: offset)
		self.bottomContainerView.transform = self.bottomContainerView.transform.translatedBy(x: 0, y: offset)
	}

	private func stickToState(_ translation: CGPoint, _ velocity: CGPoint) {
		let newState: State
		let height = self.view.bounds.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom

		if abs(velocity.y) > abs(velocity.x) {
			newState = velocity.y > 0 ? .list : .carousel
		} else {
			if self.state == .carousel {
				newState = translation.y > height / 2 ? .list : .carousel
			} else {
				newState = -translation.y < height / 2 ? .list : .carousel
			}
		}

		self.updateState(state: newState, animated: true)
	}
}

