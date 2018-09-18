import UIKit
import SlowCommon

private var adapterKey: UInt8 = 0
private typealias Adapter = ActionToCommandAdapter<UISegmentedControl, Int>

extension UISegmentedControl : IHaveAssociatedObject { }

public extension UISegmentedControl {

	var command: Command<Int>? {
		set {
			if let oldAdapter: Adapter = self.associatedObject(for: &adapterKey) {
				self.removeTarget(oldAdapter, action: #selector(oldAdapter.invoke), for: .valueChanged)
			}
			if let command = newValue {
				let adapter = Adapter(command: command) { $0.selectedSegmentIndex }
				self.setAssociatedObject(adapter, for: &adapterKey, policy: .strong)
				self.addTarget(adapter, action: #selector(adapter.invoke), for: .valueChanged)
			}
		}
		get {
			let adapter: Adapter? = self.associatedObject(for: &adapterKey)
			return adapter?.command
		}
	}

}
