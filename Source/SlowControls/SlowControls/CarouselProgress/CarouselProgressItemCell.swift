import UIKit

class CarouselProgressItemCell : UICollectionViewCell {

	var itemColor: UIColor = .gray {
		didSet {
			if oldValue != self.itemColor {
				self.updateColor()
			}
		}
	}

	var selectedItemColor: UIColor = .white {
		didSet {
			if oldValue != self.itemColor {
				self.updateColor()
			}
		}
	}

	var selectedItemScaleFactor: CGFloat = 1.5 {
		didSet {
			if oldValue != self.selectedItemScaleFactor {
				self.updateScale()
			}
		}
	}

	var scaleFactor: CGFloat = 1 {
		didSet {
			if oldValue != self.scaleFactor {
				self.updateScale()
			}
		}
	}

	var minimumScaleFactor: CGFloat = 0.33 {
		didSet {
			if oldValue != self.minimumScaleFactor {
				self.updateScale()
			}
		}
	}

	override var isSelected: Bool {
		didSet {
			if oldValue != self.isSelected {
				self.updateColor()
				UIView.animate(withDuration: 0.3) {
					self.updateScale()
				}
			}
		}
	}

	private lazy var circleView: UIView = {
		let view = UIView()
		return view
	}()

	public override init(frame: CGRect) {
		super.init(frame: frame)

		self.circleView.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.addSubview(self.circleView)
		self.updateColor()
		self.updateScale()

		NSLayoutConstraint.activate([
			self.circleView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
			self.circleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
			self.circleView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
			self.circleView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
		])
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		self.circleView.layer.cornerRadius = self.bounds.height / 2
	}

	private func updateColor() {
		self.circleView.backgroundColor = self.isSelected ? self.selectedItemColor : self.itemColor
	}

	private func updateScale() {
		if self.isSelected {
			self.circleView.transform = CGAffineTransform(scaleX: 1, y: 1)
		} else {
			var factor = self.scaleFactor
			factor = min(factor, 1)
			factor = max(factor, self.minimumScaleFactor)
			self.circleView.transform = CGAffineTransform(scaleX: factor, y: factor)
		}
	}
}
