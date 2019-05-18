import Foundation

class UserSettings : IUserSettings {

	private let storage: UserDefaults

	init() {
		self.storage = UserDefaults.standard
	}

	var floor: Int {
		get {
			return self.storage.integer(forKey: "floor")
		}
		set {
			self.storage.set(newValue, forKey: "floor")
		}
	}

	var freezerId: Int {
		get {
			return self.storage.integer(forKey: "freezerId")
		}
		set {
			self.storage.set(newValue, forKey: "freezerId")
		}
	}
}
