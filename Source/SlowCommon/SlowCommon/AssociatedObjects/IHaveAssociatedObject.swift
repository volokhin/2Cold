import Foundation

public protocol IHaveAssociatedObject: class {
	func associatedObject<T>(for key: UnsafeRawPointer) -> T?
	func removeAssociatedObject(for key: UnsafeRawPointer)
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

		objc_setAssociatedObject(
			self,
			key,
			object,
			policy.objcPolicy
		)
	}

	func removeAssociatedObject(for key: UnsafeRawPointer) {
		objc_setAssociatedObject(
			self,
			key,
			nil,
			AssociationPolicy.strong.objcPolicy
		)
	}
}
