import UIKit
import SlowCommon

private var adapterKey: UInt8 = 0
private typealias Adapter = ActionToCommandAdapter<UIButton, Void>

extension UIButton : IHaveAssociatedObject { }

public extension UIButton {

	var command: Command<Void>? {
		set {
			if let oldAdapter: Adapter = self.associatedObject(for: &adapterKey) {
				self.removeTarget(oldAdapter, action: #selector(oldAdapter.invoke), for: .touchUpInside)
			}
			if let command = newValue {
				let adapter = Adapter(command: command)
				self.setAssociatedObject(adapter, for: &adapterKey, policy: .strong)
				self.addTarget(adapter, action: #selector(adapter.invoke), for: .touchUpInside)
			}
		}
		get {
			let adapter: Adapter? = self.associatedObject(for: &adapterKey)
			return adapter?.command
		}
	}

}
