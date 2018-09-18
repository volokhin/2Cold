import Foundation

public class Container : NSObject, IContainer {

	private var registrations: [ContainerEntryKey: IContainerEntry] = [:]

	public override init() {
		super.init()
	}

	public init(log: ILog) {
		super.init()
		Logger.initialize(log: log)
	}

	@discardableResult
	public func register<T>(_ instanceType: T.Type) -> ContainerEntryBuilder<T> {

		let key = ContainerEntryKey(instanceType: T.self)
		let builder = ContainerEntryBuilder<T>(key: key)
		builder.onAssociatedKeysChanged = {
			oldKeys, newKeys in
			oldKeys.forEach { key in self.registrations.removeValue(forKey: key) }
			newKeys.forEach { key in self.registrations[key] = builder.getEntry() }
		}
		registrations[key] = builder.getEntry()
		return builder
	}

	public func resolve<T>(_ instanceType: T.Type) -> T? {
		let key = ContainerEntryKey(instanceType: T.self)
		return self.resolveAndCast(T.self, key: key)
	}

	public func resolve<T>(_ instanceType: T.Type, name: String) -> T? {
		let key = ContainerEntryKey(instanceType: T.self, name: name)
		return self.resolveAndCast(T.self, key: key)
	}

	public func unregister<T>(_ instanceType: T.Type) {
		let key = ContainerEntryKey(instanceType: T.self)
		self.registrations.removeValue(forKey: key)
	}

	public func unregister<T>(_ instanceType: T.Type, name: String) {
		let key = ContainerEntryKey(instanceType: T.self, name: name)
		self.registrations.removeValue(forKey: key)
	}

	public func contains<T>(_ instanceType: T.Type) -> Bool {
		let key = ContainerEntryKey(instanceType: T.self)
		return self.contains(key)
	}

	public func contains<T>(_ instanceType: T.Type, name: String) -> Bool {
		let key = ContainerEntryKey(instanceType: T.self, name: name)
		return self.contains(key)
	}

	internal func contains(_ key: ContainerEntryKey)  -> Bool {
		let entry = self.registrations[key]
		return entry != nil
	}

	internal func resolve(key: ContainerEntryKey) -> Any? {
		guard let entry = self.entry(by: key) else {
			return nil
		}
		return entry.getInstance(key: key, container: self)
	}

	private func resolveAndCast<T>(_ instanceType: T.Type, key: ContainerEntryKey) -> T? {
		guard let instance = self.resolve(key: key) else { return nil }
		guard let result = instance as? T else {
			Logger.warning(Messages.invalidCast(source: type(of: instance), destination: T.self))
			return nil
		}
		return result
	}

	private func entry(by key: ContainerEntryKey) -> IContainerEntry? {
		guard let entry = self.registrations[key] else {
			Logger.warning(Messages.unregisteredKey(key: key))
			return nil
		}
		return entry
	}

}
