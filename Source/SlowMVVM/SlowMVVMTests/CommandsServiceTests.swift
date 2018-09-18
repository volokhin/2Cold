import XCTest
import SlowContainer
@testable import SlowMVVM

private class TestCommand : CommandBase<Int> {
	public var parameter: Int?
	public var executeInvocationsCount = 0
	public override func execute(_ parameter: Int) {
		self.parameter = parameter
		self.executeInvocationsCount += 1
	}
}

private class TestCommandWithEmptyInit : CommandBase<Void>, IHaveEmptyInit {
	public required override init() {
		super.init()
	}
	public override func execute(_ parameter: Void) { }
}

internal class CommandsServiceTests: XCTestCase {

	private var service: ICommandsService!

	internal override func setUp() {
		super.setUp()
		self.service = CommandsService(container: Container())
	}

	// MARK: Resolve

	internal func test_do_not_resolve_unregistered_command() {
		let command = self.service.resolveCommand(TestCommand.self)
		XCTAssert(command == nil)
	}

	internal func test_do_not_resolve_unregistered_command_with_empty_init() {
		let command = self.service.resolveCommand(TestCommandWithEmptyInit.self)
		XCTAssert(command == nil)
	}

	internal func test_do_not_resolve_registered_command_with_no_factory() {
		self.service.registerCommand(TestCommand.self)
		let command = self.service.resolveCommand(TestCommand.self)
		XCTAssert(command == nil)
	}

	internal func test_resolve_registered_command_with_factory() {
		self.service
			.registerCommand(TestCommand.self)
			.withFactory { TestCommand() }
		let command = self.service.resolveCommand(TestCommand.self)
		XCTAssert(command != nil)
	}

	internal func test_resolve_registered_command_with_empty_init() {
		self.service.registerCommand(TestCommandWithEmptyInit.self)
		let command = self.service.resolveCommand(TestCommandWithEmptyInit.self)
		XCTAssert(command != nil)
	}

	internal func test_resolve_registered_command_instance() {
		let command = TestCommand()
		self.service.registerCommand(command)
		let resolvedCommand = self.service.resolveCommand(TestCommand.self)
		XCTAssert(resolvedCommand === command)
	}

	// MARK: Contains and Unregister

	internal func test_do_not_contains_unregistered_command() {
		let contains = self.service.containsCommand(TestCommand.self)
		XCTAssert(contains == false)
	}

	internal func test_contains_registered_command() {
		self.service.registerCommand(TestCommand.self)
		let contains = self.service.containsCommand(TestCommand.self)
		XCTAssert(contains == true)
	}

	internal func test_do_not_contains_after_unregister() {
		self.service.registerCommand(TestCommand.self)
		self.service.unregisterCommand(TestCommand.self)
		let contains = self.service.containsCommand(TestCommand.self)
		XCTAssert(contains == false)
	}

	internal func test_do_not_resolve_after_unregister() {
		self.service.registerCommand(Command<Any>.self)
		self.service.unregisterCommand(Command<Any>.self)
		let command = self.service.resolveCommand(Command<Any>.self)
		XCTAssert(command == nil)
	}

	// MARK: Execution

	internal func test_call_execute_block() {
		var invocationsCount = 0
		self.service
			.registerCommand(Command<Void>.self)
			.onExecute { _ in invocationsCount += 1 }
		let command = self.service.resolveCommand(Command<Void>.self)!
		command.execute(())
		XCTAssert(invocationsCount == 1)
	}

	internal func test_call_execute_block_several_times() {
		var invocationsCount = 0
		self.service
			.registerCommand(Command<Void>.self)
			.onExecute { _ in invocationsCount += 1 }
			.onExecute { _ in invocationsCount += 1 }
		let command = self.service.resolveCommand(Command<Void>.self)!
		command.execute(())
		XCTAssert(invocationsCount == 2)
	}

	internal func test_execute_command_calls_execute() {
		let command = TestCommand()
		self.service.registerCommand(command)
		self.service.executeCommand(TestCommand.self, parameter: 0)
		XCTAssert(command.executeInvocationsCount == 1)
	}

	internal func test_execute_command_passes_parameter() {
		let command = TestCommand()
		self.service.registerCommand(command)
		self.service.executeCommand(TestCommand.self, parameter: 42)
		XCTAssert(command.parameter == 42)
	}

	internal func test_execute_command_using_builder_passes_parameter() {
		var parameter = 0
		self.service
			.registerCommand(Command<Int>.self)
			.onExecute { p in parameter = p }
		self.service.executeCommand(Command<Int>.self, parameter: 42)
		XCTAssert(parameter == 42)
	}
}
