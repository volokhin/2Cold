import Foundation

internal class ContainerEntry<T> : IContainerEntry {

	internal var instance: T? {
		get {
			return self.instanceObject as? T
		}
		set {
			self.instanceObject = newValue
		}
	}

	internal var instanceFactory: ((IResolver) -> T?)?
	internal var instanceObject: Any?
	internal var instanceScope: InstanceScope?

	internal var willResolve: [(Container, ContainerEntryKey, ContainerEntry<T>) -> Void] = []
	internal var willCreate: [(Container, ContainerEntryKey, ContainerEntry<T>) -> Void] = []

	internal var didResolve: [(Container, ContainerEntryKey, ContainerEntry<T>, T?) -> Void] = []
	internal var didCreate: [(Container, ContainerEntryKey, ContainerEntry<T>, T?) -> Void] = []

	internal func getInstance(key: ContainerEntryKey, container: Container) -> Any? {
		let instanceScope = self.instanceScope ?? .instancePerRequest
		self.willResolve.forEach { f in f(container, key, self) }

		if self.instanceObject != nil, let instance = self.instance, instanceScope == .singleInstance {
			self.didResolve.forEach { f in f(container, key, self, instance) }
			return instance
		} else {
			self.willCreate.forEach { f in f(container, key, self) }
			var instance: T? = nil

			if let f = self.instanceFactory {
				instance = f(container)
			} else if let instanceWithInit = T.self as? IHaveEmptyInit.Type {
				instance = instanceWithInit.init() as? T
			} else {
				Logger.warning(Messages.unableToCreateInstance(instance: T.self))
			}

			if instanceScope == .singleInstance {
				self.instance = instance
			}

			self.didCreate.forEach { f in f(container, key, self, instance) }
			self.didResolve.forEach { f in f(container, key, self, instance) }
			return instance
		}
	}
}
