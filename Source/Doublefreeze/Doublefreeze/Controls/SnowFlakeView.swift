import Foundation
import UIKit

class SnowFlakeView : UIView {

	var isActive: Bool = false {
		didSet {
			if oldValue != self.isActive {
				self.updateIsActiveState(animated: true)
			}
		}
	}

	private lazy var snowflakeEmitterLayer: CAEmitterLayer = {
		let layer = CAEmitterLayer()
		layer.mask = self.maskLayer
		return layer
	}()

	private lazy var maskLayer: CAGradientLayer = {
		let layer = CAGradientLayer()
		layer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
		layer.startPoint = CGPoint(x: 0.5, y: 0.5)
		layer.endPoint = CGPoint(x: 1.0, y: 1.0)
		layer.type = .radial
		return layer
	}()

	private lazy var snowflakeEmitterCell: CAEmitterCell = {
		let cell = CAEmitterCell()
		return cell
	}()

	override public init(frame: CGRect) {
		super.init(frame: frame)

		self.clipsToBounds = true
		self.layer.addSublayer(self.snowflakeEmitterLayer)

		self.setupSnowflakeEmitterCell()
		self.snowflakeEmitterLayer.emitterCells = [self.snowflakeEmitterCell]

		self.updateIsActiveState(animated: false)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	internal override func layoutSubviews() {
		super.layoutSubviews()

		self.snowflakeEmitterLayer.emitterSize = CGSize(width: self.bounds.size.width, height: 0)
		self.snowflakeEmitterLayer.emitterShape = CAEmitterLayerEmitterShape.rectangle
		self.snowflakeEmitterLayer.emitterPosition = CGPoint(x: self.bounds.size.width / 2, y: -50)

		self.maskLayer.frame = CGRect(
			x: -40,
			y: -self.bounds.height / 2,
			width: self.bounds.width + 80,
			height: self.bounds.height + self.bounds.height / 2)
	}


	private func updateIsActiveState(animated: Bool) {
		let animation = CABasicAnimation(keyPath: "opacity");
		animation.toValue = self.isActive ? 1 : 0.3
		animation.duration = animated ? 5 : 0
		animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
		animation.isRemovedOnCompletion = false
		animation.fillMode = .forwards
		self.snowflakeEmitterLayer.add(animation, forKey: "opacity \(self.isActive)")
		self.snowflakeEmitterLayer.lifetime = self.isActive ? 1 : 0
	}

	private func setupSnowflakeEmitterCell() {
		self.snowflakeEmitterCell.color = UIColor.white.cgColor
		self.snowflakeEmitterCell.contents = #imageLiteral(resourceName: "snowflake").cgImage
		self.snowflakeEmitterCell.lifetime = 15
		self.snowflakeEmitterCell.birthRate = 150
		self.snowflakeEmitterCell.blueRange = 0.15
		self.snowflakeEmitterCell.alphaRange = 0.8
		self.snowflakeEmitterCell.velocity = 10
		self.snowflakeEmitterCell.velocityRange = 300
		self.snowflakeEmitterCell.scale = 0.2
		self.snowflakeEmitterCell.scaleRange = 0.5
		self.snowflakeEmitterCell.emissionRange = CGFloat.pi / 2
		self.snowflakeEmitterCell.emissionLongitude = CGFloat.pi
		self.snowflakeEmitterCell.yAcceleration = 15
		self.snowflakeEmitterCell.scaleSpeed = -0.1
		self.snowflakeEmitterCell.alphaSpeed = -0.05
	}

}
