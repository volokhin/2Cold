import Foundation

class SelectedFreezerChangedNotification {

	let freezerId: FreezerIdentifier

	init(freezerId: FreezerIdentifier) {
		self.freezerId = freezerId
	}
}
