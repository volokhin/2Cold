import Foundation

struct FreezerIdentifier : Hashable {

	let id: Int
	let floor: Int

	init(floor: Int, id: Int) {
		self.floor = floor
		self.id = id
	}

	init(model: FreezerModel) {
		self.id = model.id
		self.floor = model.floor
	}
}
