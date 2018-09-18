import Foundation

struct FreezerModel : Decodable {
	
	let id: Int
	let isEnabled: Bool
	let place: String
	let name: String
	let floor: Int
	let isDirty: Bool

	var uniqueId: FreezerIdentifier {
		return FreezerIdentifier(model: self)
	}

	init(id: Int, place: String, name: String, floor: Int) {
		self.id = id
		self.place = place
		self.name = name
		self.floor = floor
		self.isEnabled = false
		self.isDirty = false
	}

}
