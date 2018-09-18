import UIKit

public extension UIViewController {

	func addChild(_ vc: UIViewController, to view: UIView) {
		self.addChild(vc)
		vc.view.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(vc.view)
		NSLayoutConstraint.activate([
			vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			vc.view.topAnchor.constraint(equalTo: view.topAnchor),
			vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
		vc.didMove(toParent: self)
	}
}
