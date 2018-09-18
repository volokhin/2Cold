import Foundation

public protocol IResolver {
	
	func resolve<T>(_ instanceType: T.Type) -> T?
	func resolve<T>(_ instanceType: T.Type, name: String) -> T?
}
