import UIKit

public protocol IFromXib {

	static func makeFromXib() -> Self
	static func nib() -> UINib

}

public extension IFromXib where Self: UIView {

	static func nib() -> UINib {
		let bundle = Bundle.main
		let name = String(describing: Self.self)
		return UINib(nibName: name, bundle: bundle)
	}

	static func makeFromXib() -> Self {

		let bundle = Bundle.main
		let name = "\(Self.self)"
		let nibs = bundle.loadNibNamed(
			name,
			owner: nil,
			options: nil
		)
		if let view = nibs?.first as? Self {
			return view
		}

		fatalError("Unable to create \(Self.self) from nib.")
	}

}
