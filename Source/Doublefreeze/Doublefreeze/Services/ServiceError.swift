import Foundation

struct ServiceError : Error {

	let localizedDescription: String

	init(_ localizedDescription: String) {
		self.localizedDescription = localizedDescription
	}
}
