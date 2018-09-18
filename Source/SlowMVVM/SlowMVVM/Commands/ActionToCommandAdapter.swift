import Foundation

class ActionToCommandAdapter<Sender, Parameter> {

	weak var command: Command<Parameter>?
	private let adapter: (Sender) -> Parameter

	init(command: Command<Parameter>, adapter: @escaping (Sender) -> Parameter) {
		self.command = command
		self.adapter = adapter
	}

	@objc func invoke(sender: Any) {
		guard let sender = sender as? Sender else { return }
		let parameter = self.adapter(sender)
		self.command?.execute(parameter: parameter)
	}
}

extension ActionToCommandAdapter where Parameter == Void {
	convenience init(command: Command<Parameter>) {
		self.init(command: command, adapter: { _ in () })
	}
}
