import Foundation

protocol IUserSettings {
	var freezerId: FreezerIdentifier? { get set }
	var cache: [FreezerModel] { get set }
}
