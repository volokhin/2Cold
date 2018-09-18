import Foundation

public extension UIView {

	func activate(_ constraints: NSLayoutConstraint...) {
		self.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(constraints)
	}
}
