import Foundation
import SlowHelpers
import SlowCommon

protocol IFreezersService {

	var updated: Event<[FreezerModel]> { get }
	func updateAsync()

	func freezers() -> [FreezerModel]
	func enable(freezer: FreezerIdentifier)
	func disable(freezer: FreezerIdentifier)
}
