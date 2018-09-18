import Foundation

internal protocol IContainerEntry {
	
	var instanceObject: Any? { get }
	var instanceScope: InstanceScope? { get }

	func getInstance(key: ContainerEntryKey, container: Container) -> Any?
}
