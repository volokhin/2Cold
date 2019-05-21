import Foundation

class UserSettings : IUserSettings {

	private let storage: UserDefaults
	private let encoder: JSONEncoder
	private let decoder: JSONDecoder

	private var freezerIdStorage: FreezerIdentifier? {
		get {
			let data = self.storage.data(forKey: "freezerId")
			if let data = data {
				let id = try? self.decoder.decode(FreezerIdentifier.self, from: data)
				return id
			}
			return nil
		}
		set {
			let freezerIdData = try? self.encoder.encode(newValue)
			if let data = freezerIdData {
				self.storage.set(data, forKey: "freezerId")
			}
		}
	}

	private var cacheStorage: [FreezerModel] {
		get {
			let data = self.storage.data(forKey: "cache")
			if let data = data {
				let items = try? self.decoder.decode([FreezerModel].self, from: data)
				return items ?? []
			}
			return []
		}
		set {
			let cacheData = try? self.encoder.encode(self.cache)
			if let data = cacheData {
				self.storage.set(data, forKey: "cache")
			}
		}
	}

	var freezerId: FreezerIdentifier? = nil {
		didSet {
			self.freezerIdStorage = self.freezerId
		}
	}

	var cache: [FreezerModel] = [] {
		didSet {
			self.cacheStorage = self.cache
		}
	}

	init() {
		self.storage = UserDefaults.standard
		self.encoder = JSONEncoder()
		self.decoder = JSONDecoder()
		self.freezerId = self.freezerIdStorage
		self.cache = self.cacheStorage
	}

}
