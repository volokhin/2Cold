import Foundation
import SlowHelpers
import SlowCommon

class FreezersService : IFreezersService {

	private var fallbackCache: [FreezerModel] = [
		// 8 этаж
		FreezerModel(id: 2, place: "D&R", name: "Александр Вадимович", floor: 8),
		FreezerModel(id: 3, place: "D&R", name: "Кирилл", floor: 8),
		FreezerModel(id: 4, place: "Кухня", name: "Светлана", floor: 8),
		FreezerModel(id: 5, place: "HR", name: "Оксана", floor: 8),
		FreezerModel(id: 6, place: "Камчатка", name: "Камчатка", floor: 8),
		FreezerModel(id: 7, place: "Core", name: "Данил", floor: 8),
		FreezerModel(id: 8, place: "Support", name: "Юля", floor: 8),
		FreezerModel(id: 9, place: "CoreNavi", name: "Artöm", floor: 8),
		FreezerModel(id: 10, place: "iOS", name: "Даша", floor: 8),
		FreezerModel(id: 11, place: "iOS", name: "Маша", floor: 8),
		FreezerModel(id: 12, place: "iOS", name: "Вадим", floor: 8),
		FreezerModel(id: 13, place: "Android", name: "Руслан", floor: 8),
		FreezerModel(id: 14, place: "Android", name: "Сергей", floor: 8),
		// 5 этаж
		FreezerModel(id: 10, place: "Unix", name: "Юра", floor: 5),
		FreezerModel(id: 11, place: "Кухня", name: "Евгений", floor: 5),
		FreezerModel(id: 12, place: "Карта", name: "Анатолий", floor: 5),
		FreezerModel(id: 14, place: "Карта", name: "Стёпа", floor: 5),
	]

	private lazy var cache: [FreezerModel] = {
		let cache = self.settings.cache
		return cache.count > 0 ? cache : self.fallbackCache
	}()

	let updated: Event<[FreezerModel]> = .init()

	private let httpClient: IFreezersHttpClient
	private var settings: IUserSettings

	init(httpClient: IFreezersHttpClient, settings: IUserSettings) {
		self.httpClient = httpClient
		self.settings = settings
	}

	func freezers() -> [FreezerModel] {
		return self.cache
	}

	func updateAsync() {
		self.httpClient.fetchFreezers(queue: .main) {
			[weak self] result in
			guard let self = self else { return }
			self.process(result)
		}
	}

	func enable(freezer: FreezerIdentifier) {
		self.httpClient.enable(floor: freezer.floor, id: freezer.id, queue: .main) {
			[weak self] result in
			guard let self = self else { return }
			self.process(result)
		}
	}

	func disable(freezer: FreezerIdentifier) {
		self.httpClient.disable(floor: freezer.floor, id: freezer.id, queue: .main) {
			[weak self] result in
			guard let self = self else { return }
			self.process(result)
		}
	}

	private func process(_ result: Result<[FreezerModel], Error>) {
		switch result {
		case .success(let freezers):
			self.cache = freezers
			self.settings.cache = freezers
		case .failure(let error):
			print(error)
			break
		}
		self.updated.raise(self.cache)
	}

}
