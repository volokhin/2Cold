import UIKit
import SlowMVVM

class FreezersListVC : ViewControllerBase<FreezersListVM> {

	private lazy var tableView: BindableTableView = {
		let tableView = BindableTableView()
		tableView.table.backgroundColor = .clear
		tableView.table.contentInset = UIEdgeInsets(top: self.headerHeight, left: 0, bottom: self.headerHeight, right: 0)
		tableView.table.contentOffset = CGPoint(x: 0, y: -self.headerHeight)
		tableView.table.alwaysBounceVertical = true
		tableView.table.bounces = true
		tableView.table.separatorStyle = .none
		tableView.scrollViewDidScroll.subscribe(self) {
			this, scrollView in
			this.scrollViewDidScroll(scrollView)
		}
		return tableView
	}()

	private lazy var topGradientView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		view.layer.cornerRadius = 75
		view.layer.shadowColor = UIColor.darkSkyBlue.cgColor
		view.layer.shadowRadius = 75 / 2
		view.layer.shadowOpacity = 1
		return view
	}()

	private lazy var bottomGradientView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		view.layer.cornerRadius = 75
		view.layer.shadowColor = UIColor.darkSkyBlue.cgColor
		view.layer.shadowRadius = 75 / 2
		view.layer.shadowOpacity = 1
		return view
	}()

	private lazy var carouselButton: UIButton = {
		let button = UIButton(type: .system)
		button.alpha = 1
		button.backgroundColor = .clear
		button.tintColor = .white
		button.layer.cornerRadius = 16
		button.setImage(UIImage(named: "ListIcon"), for: .normal)
		return button
	}()

	private lazy var segmentedControl: UISegmentedControl = {
		let control = UISegmentedControl(items: ["5 этаж", "8 этаж"])
		let font = UIFont.segmentedControlFont
		control.tintColor = .white
		control.layer.cornerRadius = 14
		control.layer.borderColor = UIColor.white.cgColor
		control.layer.borderWidth = 1
		control.layer.masksToBounds = true

		control.setTitleTextAttributes([
			NSAttributedString.Key.font: UIFont.segmentedControlFont,
			NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
		control.setTitleTextAttributes([
			NSAttributedString.Key.font: UIFont.segmentedControlFont,
			NSAttributedString.Key.foregroundColor: UIColor.charcoal], for: .selected)

		return control
	}()

	private let headerHeight: CGFloat = 100

	var isActive: Bool = false {
		didSet {
			if oldValue != self.isActive {
				self.updateIsActiveState(animated: true)
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.view.backgroundColor = .white
		self.view.addSubview(self.topGradientView)
		self.view.addSubview(self.tableView)
		self.view.addSubview(self.bottomGradientView)
		self.view.addSubview(self.carouselButton)
		self.view.addSubview(self.segmentedControl)

		self.topGradientView.activate(
			self.topGradientView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
			self.topGradientView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).withPriority(.defaultLow),
			self.topGradientView.heightAnchor.constraint(equalTo: self.self.topGradientView.widthAnchor),
			self.topGradientView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
		)

		self.bottomGradientView.activate(
			self.bottomGradientView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
			self.bottomGradientView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).withPriority(.defaultLow),
			self.bottomGradientView.heightAnchor.constraint(equalTo: self.self.bottomGradientView.widthAnchor),
			self.bottomGradientView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
		)

		self.segmentedControl.activate(
			self.segmentedControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 24),
			self.segmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			self.segmentedControl.widthAnchor.constraint(equalToConstant: 150)
		)

		self.carouselButton.activate(
			self.carouselButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
			self.carouselButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			self.carouselButton.widthAnchor.constraint(equalToConstant: 96),
			self.carouselButton.heightAnchor.constraint(equalToConstant: 32)
		)

		self.updateIsActiveState(animated: false)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.tableView.frame = self.view.bounds

		self.topGradientView.layer.shadowPath = UIBezierPath(roundedRect: self.topGradientView.bounds, cornerRadius: 75).cgPath
		self.topGradientView.transform = CGAffineTransform(translationX: 0, y: self.topGradientView.bounds.height * 45 / 248)

		self.bottomGradientView.layer.shadowPath = UIBezierPath(roundedRect: self.bottomGradientView.bounds, cornerRadius: 75).cgPath
		self.bottomGradientView.transform = CGAffineTransform(translationX: 0, y: -self.bottomGradientView.bounds.height * 55 / 248)
	}

	override func viewModelChanged() {
		super.viewModelChanged()
		guard let vm = self.viewModel else { return }
		self.carouselButton.command = vm.openCarouselCommand
		self.segmentedControl.command = vm.changeFloorCommand
		self.segmentedControl.selectedSegmentIndex = vm.selectedFloorIndex
		self.tableView.dataSource = vm.items

		//vm.onReload = {
//			[weak self] in
//			guard let self = self else { return }
//			//self.tableView.reloadData()
//		}

		vm.onSelectedFreezerChanged = {
			[weak self] index in
			guard let self = self else { return }
			guard !self.isActive else { return }
			//self.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: false)
		}
	}

	private func updateIsActiveState(animated: Bool) {
		let animation = CABasicAnimation(keyPath: "shadowOpacity");
		animation.toValue = self.isActive ? 1 : 0
		animation.fillMode = .forwards
		animation.duration = self.isActive && animated ? 0.6 : 0.0
		animation.isRemovedOnCompletion = false
		animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
		self.bottomGradientView.layer.add(animation, forKey: "shadowOpacity \(self.isActive)")

		let timing = UISpringTimingParameters(damping: 1, response: 0.3)
		let animator = UIViewPropertyAnimator(duration: 0.4, timingParameters: timing)
		animator.addAnimations {
			self.carouselButton.alpha = self.isActive ? 1 : 0
		}
		animator.startAnimation()

		if !animated {
			animator.stopAnimation(false)
			animator.finishAnimation(at: .end)
		}
	}

	private func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offset = scrollView.contentOffset.y + self.headerHeight + self.view.safeAreaInsets.top
		let translation = max(offset, 0)
		self.segmentedControl.transform = CGAffineTransform(translationX: 0, y: -translation)
		let threshold = self.view.bounds.height / 1
		let opacity = min(max((threshold - offset) / threshold, 0), 1)
		self.topGradientView.layer.shadowOpacity = Float(opacity)
	}
}
