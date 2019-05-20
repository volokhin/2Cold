import Foundation

class UserSettings : IUserSettings {

	private let storage: UserDefaults
	private let encoder: JSONEncoder
	private let decoder: JSONDecoder

	init() {
		self.storage = UserDefaults.standard
		self.encoder = JSONEncoder()
		self.decoder = JSONDecoder()
	}

	lazy var freezerId: FreezerIdentifier? = {
		let data = self.storage.data(forKey: "freezerId")
		if let data = data {
			let id = try? self.decoder.decode(FreezerIdentifier.self, from: data)
			print("read floor", id?.floor)
			print("read id", id?.id)
			return id
		}
		return nil
	}()

	lazy var cache: [FreezerModel] = {
		let data = self.storage.data(forKey: "cache")
		if let data = data {
			let items = try? self.decoder.decode([FreezerModel].self, from: data)
			return items ?? []
		}
		return []
	}()

	func flush() {
		let freezerIdData = try? self.encoder.encode(self.freezerId)
		if let data = freezerIdData {
			self.storage.set(data, forKey: "freezerId")
		}

		let cacheData = try? self.encoder.encode(self.cache)
		if let data = cacheData {
			self.storage.set(data, forKey: "cache")
		}

		print("flush floor", self.freezerId?.floor)
		print("flush id", self.freezerId?.id)
	}
}
