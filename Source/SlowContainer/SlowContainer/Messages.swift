import Foundation

internal class Messages {

	// MERK: Container

	internal static func unregisteredKey(key: ContainerEntryKey) -> String {
		return """
		Entry for key '\(key)' is not registered in the container.
		"""
	}

	internal static func invalidCast(source: Any.Type, destination: Any.Type) -> String {
		return """
		Unable to cast an instance of type '\(source)' to the type '\(destination)'.
		"""
	}

	internal static func redundantFactoryDeclaration(factory: Any.Type, instance: Any.Type) -> String {
		return """
		Factory '\(factory)' for a container instance '\(instance)' has already been specified.
		It will be replaced by the new factory. Consider removing redundant factory declaration.
		"""
	}

	internal static func redundantNameDeclaration(oldName: String, newName: String, instance: Any.Type) -> String {
		return """
		Name '\(oldName)' for a container instance '\(instance)' has already been specified.
		It will be replaced by the new name '\(newName)'. Consider removing redundant name declaration.
		"""
	}

	internal static func redundantScopeDeclaration(oldScope: InstanceScope, newScope: InstanceScope, instance: Any.Type) -> String {
		return """
		Instance scoupe '\(oldScope)' for a container instance '\(instance)' has already been specified.
		It will be replaced by the new scope '\(newScope)'. Consider removing redundant scope declaration.
		"""
	}

	internal static func unableToCreateInstance(instance: Any.Type) -> String {
		return """
		Unable to create an instance of '\(instance)' type. The type does not conform to \(IHaveEmptyInit.self) and no
		factory or init declatation is specified in the Container.
		"""
	}
	
	internal static func unableToCreateVC(vm: String) -> String {
		return """
		Unable to create VC for VM '\(vm)'.
		"""
	}
}
