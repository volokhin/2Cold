import Foundation

public enum AssociationPolicy {

	case strong
	case copy
	case weak

	var objcPolicy: objc_AssociationPolicy {
		switch self {
		case .strong:
			return .OBJC_ASSOCIATION_RETAIN_NONATOMIC
		case .copy:
			return .OBJC_ASSOCIATION_COPY_NONATOMIC
		case .weak:
			return .OBJC_ASSOCIATION_ASSIGN
		}
	}
}
