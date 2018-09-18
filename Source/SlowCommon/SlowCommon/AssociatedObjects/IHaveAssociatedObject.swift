import Foundation

public protocol IHaveAssociatedObject: class {
	func associatedObject<T>(for key: UnsafeRawPointer) -> T?
	func setAssociatedObject<T>(
		_ object: T,
		for key: UnsafeRawPointer,
		policy: AssociationPolicy
	)
}

public extension IHaveAssociatedObject {

	func associatedObject<T>(for key: UnsafeRawPointer) -> T? {
		return objc_getAssociatedObject(self, key) as? T
	}

	func setAssociatedObject<T>(
		_ object: T,
		for key: UnsafeRawPointer,
		policy: AssociationPolicy) {

		return objc_setAssociatedObject(
			self,
			key,
			object,
			policy.objcPolicy
		)
	}
}
