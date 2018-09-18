import Foundation

protocol IFreezersHttpClient {
	func fetchFreezers(queue: DispatchQueue, completion: @escaping (Result<[FreezerModel], Error>) -> Void)
	func enable(floor: Int, id: Int, queue: DispatchQueue, completion: @escaping (Result<[FreezerModel], Error>) -> Void)
	func disable(floor: Int, id: Int, queue: DispatchQueue, completion: @escaping (Result<[FreezerModel], Error>) -> Void)
}
