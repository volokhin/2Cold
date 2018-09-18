import Foundation

public protocol IContainer : IResolver {

	@discardableResult
	func register<T>(_ instanceType: T.Type) -> ContainerEntryBuilder<T>

	func unregister<T>(_ instanceType: T.Type)

	func unregister<T>(_ instanceType: T.Type, name: String)

	func contains<T>(_ instanceType: T.Type) -> Bool

	func contains<T>(_ instanceType: T.Type, name: String) -> Bool
}
