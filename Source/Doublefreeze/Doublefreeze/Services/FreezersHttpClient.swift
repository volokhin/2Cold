import Foundation

class FreezersHttpClient : IFreezersHttpClient {

	//private let baseUrlString = "http://localhost:5000/api/ac"
	private let baseUrlString = "http://157.230.208.168/api/ac"

	private let decoder = JSONDecoder()

	func fetchFreezers(queue: DispatchQueue, completion: @escaping (Result<[FreezerModel], Error>) -> Void) {
		let url = URL(string: "\(self.baseUrlString)/list")!
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		self.executeRequest(request, queue: queue, completion: completion)
	}

	func enable(floor: Int, id: Int, queue: DispatchQueue, completion: @escaping (Result<[FreezerModel], Error>) -> Void) {
		let url = URL(string: "\(self.baseUrlString)/enable/\(floor)/\(id)")!
		self.changeFreezerState(url: url, queue: queue, completion: completion)
	}

	func disable(floor: Int, id: Int, queue: DispatchQueue, completion: @escaping (Result<[FreezerModel], Error>) -> Void) {
		let url = URL(string: "\(self.baseUrlString)/disable/\(floor)/\(id)")!
		self.changeFreezerState(url: url, queue: queue, completion: completion)
	}

	private func changeFreezerState(url: URL, queue: DispatchQueue, completion: @escaping (Result<[FreezerModel], Error>) -> Void) {
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		self.executeRequest(request, queue: queue, completion: completion)
	}

	private func executeRequest(_ request: URLRequest, queue: DispatchQueue, completion: @escaping (Result<[FreezerModel], Error>) -> Void) {
		let task = URLSession.shared.dataTask(with: request) {
			[weak self] data, response, error in
			guard let self = self else { return }
			if let error = error {
				queue.async { completion(Result.failure(error)) }
			} else if let data = data, let response = response as? HTTPURLResponse {
				if response.statusCode == 200 {
					do {
						let result = try self.decoder.decode([FreezerModel].self, from: data)
						queue.async { completion(Result.success(result)) }
					} catch let error {
						queue.async { completion(Result.failure(error)) }
					}
				} else {
					let errorText = String(data: data, encoding: .utf8)
					let error = ServiceError(errorText ?? "Server returned \(response.statusCode) status code.")
					queue.async { completion(Result.failure(error)) }
				}
			}
		}
		task.resume()
	}
}
