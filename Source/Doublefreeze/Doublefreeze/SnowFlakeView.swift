import Foundation
import UIKit

internal class SnowFlakeView : UIView {

	private let snowflakeEmitterLayer = CAEmitterLayer()
	private let snowflakeEmitterCell = CAEmitterCell()

	override public init(frame: CGRect) {
		super.init(frame: frame)
		self.commonInit()
	}

	required public init?(coder decoder: NSCoder) {
		super.init(coder: decoder)
		self.commonInit()
	}

//	internal override func layoutSubviews() {
//		super.layoutSubviews()
//		self.snowflakeEmitterLayer.emitterSize = CGSize(width: 50, height: 50)
//		self.snowflakeEmitterLayer.emitterShape = kCAEmitterLayerRectangle
//		self.snowflakeEmitterLayer.emitterPosition = CGPoint(x:  self.bounds.width / 2, y: 0)
//	}

	private func commonInit() {


		let slider = UISlider()
		slider.frame = CGRect(x: 0, y: self.bounds.height - 100, width: self.bounds.width, height: 100)
		self.addSubview(slider)


		slider.minimumValue = 0
		slider.maximumValue = 20


		slider.addTarget(self, action: #selector(self.sliderValueChanged), for: UIControl.Event.valueChanged)




		//self.setupRootLayer()
		self.backgroundColor = UIColor.black
		//self.layer.backgroundColor = UIColor.blue.withAlphaComponent(0.5).cgColor
		self.setupSnowflakeEmitterLayer()
		self.setupSnowflakeEmitterCell()
		self.snowflakeEmitterLayer.emitterCells = [self.snowflakeEmitterCell]
		self.layer.addSublayer(self.snowflakeEmitterLayer)
	}

//	private func setupRootLayer() {
//		rootLayer.backgroundColor = NSColor(currentColorSchemeHex: 0x70a3bc).cgColor
//	}

	private func setupSnowflakeEmitterLayer() {
		self.snowflakeEmitterLayer.emitterSize = self.bounds.size
		//self.snowflakeEmitterLayer.emitterSize = CGSize(width: 100, height: 100)
		self.snowflakeEmitterLayer.emitterShape = CAEmitterLayerEmitterShape.rectangle
		self.snowflakeEmitterLayer.emitterPosition = CGPoint(x: self.bounds.width / 2, y: 0)
		//self.snowflakeEmitterLayer.emitterPosition = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
	}

	private func setupSnowflakeEmitterCell() {
		self.snowflakeEmitterCell.color = UIColor.white.cgColor
		self.snowflakeEmitterCell.contents = #imageLiteral(resourceName: "snowflake").cgImage
		self.snowflakeEmitterCell.lifetime = 5.5
		self.snowflakeEmitterCell.birthRate = 200
		self.snowflakeEmitterCell.blueRange = 0.15
		self.snowflakeEmitterCell.alphaRange = 0.4
		self.snowflakeEmitterCell.velocity = 10
		self.snowflakeEmitterCell.velocityRange = 300
		self.snowflakeEmitterCell.scale = 0.2
		self.snowflakeEmitterCell.scaleRange = 1
		self.snowflakeEmitterCell.emissionRange = CGFloat.pi
		self.snowflakeEmitterCell.emissionLongitude = CGFloat.pi
		self.snowflakeEmitterCell.yAcceleration = 70
		self.snowflakeEmitterCell.scaleSpeed = -0.1
		self.snowflakeEmitterCell.alphaSpeed = -0.05
	}


	@objc private func sliderValueChanged(sender: UISlider) {
		self.snowflakeEmitterLayer.velocity = sender.value
		self.snowflakeEmitterLayer.birthRate = sender.value
	}

}
