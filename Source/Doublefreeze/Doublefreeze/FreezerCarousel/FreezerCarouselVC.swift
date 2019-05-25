import UIKit
import SlowMVVM
import SlowControls
import SlowHelpers

class FreezerCarouselVC : ViewControllerBase<FreezerCarouselVM> {

	private lazy var collectionView: BindableCollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumInteritemSpacing = 0;
		layout.minimumLineSpacing = 0;
		let collectionView = BindableCollectionView(layout: layout)
		collectionView.collection.backgroundColor = .clear
		collectionView.collection.isPagingEnabled = true
		collectionView.collection.showsHorizontalScrollIndicator = false
		collectionView.collection.delegate = self
		collectionView.firstCellWillLoad.subscribe(self) {
			this in
			this.updateSelectedItem()
		}
		return collectionView
	}()

	private lazy var listButton: UIButton = {
		let button = UIButton(type: .system)
		button.alpha = 0
		button.tintColor = .white
		button.setImage(UIImage(named: "ListIcon"), for: .normal)
		return button
	}()

	private lazy var containerView: UIView = {
		let view = UIView()
		view.isUserInteractionEnabled = false
		return view
	}()

	private lazy var toggleView: ToggleView = {
		let view = ToggleView()
		return view
	}()

	private lazy var progressControl: CarouselProgressControl = {
		let progress = CarouselProgressControl()
		progress.itemColor = UIColor.pinkishGrey.withAlphaComponent(0.5)
		progress.selectedItemColor = .white
		progress.itemDiameter = 9
		progress.itemsOffset = 9
		progress.selectedItemScaleFactor = 12 / 9
		progress.itemsCount = 0
		progress.visibleItemsCount = 7
		return progress
	}()

	private lazy var snowFlakeView: SnowFlakeView = {
		let view = SnowFlakeView()
		view.alpha = 1
		return view
	}()

	private lazy var topGradientView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		view.layer.cornerRadius = 75
		view.layer.shadowColor = UIColor.darkSkyBlue.cgColor
		view.layer.shadowRadius = 75 / 2
		view.layer.shadowOpacity = 0
		return view
	}()

	private lazy var bottomGradientView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		view.layer.cornerRadius = 75
		view.layer.shadowColor = UIColor.darkSkyBlue.cgColor
		view.layer.shadowRadius = 75 / 2
		view.layer.shadowOpacity = 0
		return view
	}()

	private var strokeViews: [UIView] = []
	private var isFirstCellLoaded: Bool = false

	private var isCurrentFreezerEnabled: Bool = false {
		didSet {
			if oldValue != self.isCurrentFreezerEnabled {
				self.updateState(animated: true)
			}
		}
	}

	var isActive: Bool = false {
		didSet {
			if oldValue != self.isActive {
				self.updateIsActiveState(animated: true)
			}
		}
	}
	
	override init() {
		super.init()
		self.view.backgroundColor = .charcoal
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.view.clipsToBounds = true

		self.view.addSubview(self.topGradientView)
		self.view.addSubview(self.snowFlakeView)
		self.view.addSubview(self.bottomGradientView)
		self.view.addSubview(self.collectionView)
		self.view.addSubview(self.containerView)
		self.view.addSubview(self.progressControl)
		self.view.addSubview(self.toggleView)
		self.view.addSubview(self.listButton)
		self.containerView.addSubview(self.progressControl)

		self.containerView.activate(
			self.containerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
			self.containerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -312).withPriority(.defaultLow),
			self.containerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
			self.containerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
		)

		self.progressControl.activate(
			self.progressControl.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
			self.progressControl.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor, constant: 85)
		)

		self.toggleView.activate(
			self.toggleView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			self.toggleView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -48)
		)

		self.listButton.activate(
			self.listButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
			self.listButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			self.listButton.widthAnchor.constraint(equalToConstant: 48),
			self.listButton.heightAnchor.constraint(equalToConstant: 48)
		)

		self.topGradientView.activate(
			self.topGradientView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
			self.topGradientView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).withPriority(.defaultLow),
			self.topGradientView.heightAnchor.constraint(equalTo: self.topGradientView.widthAnchor),
			self.topGradientView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
		)

		self.snowFlakeView.activate(
			self.snowFlakeView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			self.snowFlakeView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			self.snowFlakeView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
			self.snowFlakeView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
			self.snowFlakeView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 150)
		)

		self.bottomGradientView.activate(
			self.bottomGradientView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
			self.bottomGradientView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).withPriority(.defaultLow),
			self.bottomGradientView.heightAnchor.constraint(equalTo: self.self.bottomGradientView.widthAnchor),
			self.bottomGradientView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
		)

		for i in 0...4 {
			let view = UIView()
			view.alpha = 0.2
			view.backgroundColor = .clear
			view.layer.borderWidth = 1
			view.layer.borderColor = UIColor.orangeyRed.cgColor
			view.isUserInteractionEnabled = false
			self.view.insertSubview(view, belowSubview: self.toggleView)
			let heightConstant = self.view.bounds.width * CGFloat(60.0 / 320.0) + CGFloat(1 * (i + 1))
			let widthConstant = self.view.bounds.width * CGFloat(60.0 / 320.0) + CGFloat(16 * (i + 1))
			let previousView: UIView
			let previousIndex = i - 1

			if previousIndex >= 0 && previousIndex < self.strokeViews.count {
				previousView = self.strokeViews[previousIndex]
			} else {
				previousView = self.toggleView
			}

			view.activate(
				view.centerYAnchor.constraint(equalTo: self.toggleView.centerYAnchor),
				view.centerXAnchor.constraint(equalTo: self.toggleView.centerXAnchor),
				view.widthAnchor.constraint(equalTo: previousView.widthAnchor, constant: CGFloat(widthConstant)),
				view.heightAnchor.constraint(equalTo: previousView.heightAnchor, constant: CGFloat(heightConstant))
			)

			self.strokeViews.append(view)
		}

		self.updateState(animated: false)
		self.updateIsActiveState(animated: false)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		self.collectionView.frame = self.view.bounds

		self.topGradientView.layer.shadowPath = UIBezierPath(roundedRect: self.topGradientView.bounds, cornerRadius: 75).cgPath
		self.bottomGradientView.layer.shadowPath = UIBezierPath(roundedRect: self.bottomGradientView.bounds, cornerRadius: 75).cgPath

		self.topGradientView.transform = CGAffineTransform(translationX: 0, y: self.topGradientView.bounds.height * 0.275)
		self.bottomGradientView.transform = CGAffineTransform(translationX: 0, y: -self.bottomGradientView.bounds.height * 0.66)

		self.strokeViews.dropLast().forEach {
			$0.layer.cornerRadius = $0.bounds.height / 2
		}
	}

	override func viewModelChanged() {
		super.viewModelChanged()

		guard let vm = self.viewModel else { return }
		self.listButton.command = vm.openListCommand
		self.progressControl.itemsCount = vm.items.count
		self.toggleView.viewModel = vm.selectedItem
		self.isCurrentFreezerEnabled = vm.selectedItem?.isEnabled ?? false
		self.collectionView.dataSource = vm.items

		self.updateSelectedItem()

		vm.onReload = {
			[weak self] in
			self?.progressControl.itemsCount = vm.items.count
		}
	}

	private func updateSelectedItem() {
		guard let vm = self.viewModel else { return }
		if let selectedItem = vm.selectedItem {
			let index = self.viewModel?.items.firstIndex { $0 === selectedItem }
			if let index = index {
				let indexPath = IndexPath(row: index, section: 0)
				self.progressControl.selectedItemIndex = index
				if !self.collectionView.collection.isDragging && !self.collectionView.collection.isDecelerating {
					self.collectionView.collection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
				}
			}
		}
	}

	private func updateIsActiveState(animated: Bool) {
		let animation = CABasicAnimation(keyPath: "shadowOpacity");
		animation.toValue = self.isActive ? 1 : 0
		animation.fillMode = .forwards
		animation.duration = self.isActive && animated ? 0.6 : 0.0
		animation.isRemovedOnCompletion = false
		animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
		self.topGradientView.layer.add(animation, forKey: "shadowOpacity \(self.isActive)")

		let timing = UISpringTimingParameters(damping: 1, response: 0.3)
		let animator = UIViewPropertyAnimator(duration: 0.4, timingParameters: timing)
		animator.addAnimations {
			self.listButton.alpha = self.isActive ? 1 : 0
			self.snowFlakeView.alpha = self.isActive ? 1 : 0
		}
		animator.startAnimation()

		if !animated {
			animator.stopAnimation(false)
			animator.finishAnimation(at: .end)
		}
	}

	private func updateState(animated: Bool) {
		self.updateTopShadow(animated: animated)
		self.updateBottomShadow(animated: animated)
		self.updateStrokeViews(animated: animated)
	}

	private func updateTopShadow(animated: Bool) {
		let animation = CABasicAnimation(keyPath: "shadowColor");
		animation.toValue = self.isCurrentFreezerEnabled ? UIColor.darkSkyBlue.cgColor : UIColor.orangeyRed.cgColor
		animation.duration = animated ? 0.6 : 0.0
		animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
		animation.isRemovedOnCompletion = false
		animation.fillMode = .forwards
		self.topGradientView.layer.add(animation, forKey: "shadowColor \(self.isCurrentFreezerEnabled)")
		self.snowFlakeView.isActive = self.isCurrentFreezerEnabled
	}

	private func updateBottomShadow(animated: Bool) {
		let animation = CABasicAnimation(keyPath: "shadowOpacity");
		animation.toValue = self.isCurrentFreezerEnabled ? 0.75 : 0
		animation.duration = animated ? 0.6 : 0.0
		animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
		animation.isRemovedOnCompletion = false
		animation.fillMode = .forwards
		self.bottomGradientView.layer.add(animation, forKey: "shadowOpacity \(self.isCurrentFreezerEnabled)")
	}

	private func updateStrokeViews(animated: Bool) {
		self.strokeViews.enumerated().forEach {
			let animation = CABasicAnimation(keyPath: "borderColor");
			animation.toValue = self.isCurrentFreezerEnabled ? UIColor.darkSkyBlue.cgColor : UIColor.orangeyRed.cgColor
			animation.duration = animated ? 0.6 : 0.0
			animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
			animation.isRemovedOnCompletion = false
			animation.fillMode = .forwards
			$0.element.layer.add(animation, forKey: "borderColor \(self.isCurrentFreezerEnabled)")
		}

	}

}

extension FreezerCarouselVC : UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return self.view.bounds.size
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		guard let vm = self.viewModel else { return }
		if let selectedCell = self.selectedCell(), let path = self.collectionView.collection.indexPath(for: selectedCell) {
			self.progressControl.selectedItemIndex = path.row
			if path.row >= 0 && path.row < vm.items.count {
				vm.selectedItem = vm.items[path.row]
			}
		}
	}

	private func selectedCell() -> UICollectionViewCell? {
		var maxWidth: CGFloat = 0
		var selectedCell: UICollectionViewCell?
		for cell in self.collectionView.collection.visibleCells {
			var frame = cell.superview!.convert(cell.frame, to: self.view)
			frame = frame.intersection(self.collectionView.frame)
			if frame.width > maxWidth {
				selectedCell = cell
				maxWidth = frame.width
			}
		}
		return selectedCell
	}

}
