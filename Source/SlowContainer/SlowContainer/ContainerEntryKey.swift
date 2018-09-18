import Foundation

internal class ContainerEntryKey {

	internal let instanceType: Any.Type
	internal let name: String?

	internal convenience init(instanceType: Any.Type) {
		self.init(instanceType: instanceType, name: nil)
	}

	internal init(instanceType: Any.Type, name: String?) {
		self.instanceType = instanceType
		self.name = name
	}
}

extension ContainerEntryKey : Hashable {

	func hash(into hasher: inout Hasher) {
		hasher.combine(ObjectIdentifier(self.instanceType))
		hasher.combine(self.name?.hashValue ?? 0)
	}

	static func ==(lhs: ContainerEntryKey, rhs: ContainerEntryKey) -> Bool {
		return lhs.instanceType == rhs.instanceType && lhs.name == rhs.name
	}
}

extension ContainerEntryKey : CustomStringConvertible {

	internal var description: String {
		if let name = self.name {
			return "\(self.instanceType):\(name)"
		} else {
			return "\(self.instanceType)"
		}
	}
}
