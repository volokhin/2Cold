import Foundation

class EnabledChangedNotification {

	let freezerId: FreezerIdentifier
	let isEnabled: Bool

	init(freezerId: FreezerIdentifier, isEnabled: Bool) {
		self.freezerId = freezerId
		self.isEnabled = isEnabled
	}
}
