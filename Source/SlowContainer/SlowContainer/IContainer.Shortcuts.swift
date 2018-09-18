import Foundation

public extension IContainer {

	@discardableResult
	func register() -> ContainerEntryBuilder<Any> {
		return self.register(Any.self)
	}

	@discardableResult
	func register<T>(_ instanceType: T.Type, _ factory: @escaping (IResolver) -> T?) -> ContainerEntryBuilder<T> {
		return self.register(T.self).withFactory(factory)
	}

	@discardableResult
	func registerPerRequest<T>(_ instanceType: T.Type, _ factory: @escaping (IResolver) -> T?) -> ContainerEntryBuilder<T> {
		return self.register(T.self).withFactory(factory).perRequest()
	}

	@discardableResult
	func registerSingleton<T>(_ instanceType: T.Type, _ factory: @escaping (IResolver) -> T?) -> ContainerEntryBuilder<T> {
		return self.register(T.self).withFactory(factory).singleInstance()
	}
}
