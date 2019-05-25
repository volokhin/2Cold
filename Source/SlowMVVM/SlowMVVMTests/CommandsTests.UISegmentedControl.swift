import XCTest
@testable import SlowMVVM
import SlowCommon

private class ViewModel {
	var invocationsCount: Int = 0
	var parameter: Int? = nil
	var command: Command<Int>? = nil
	init() {
		self.command = Command(self) {
			this, parameter in
			this.invocationsCount = this.invocationsCount + 1
			this.parameter = parameter
		}
	}
}

internal class CommandsTests_UISegmentedControl: XCTestCase {

	private var control: UISegmentedControl!

	internal override func setUp() {
		super.setUp()
		self.control = UISegmentedControl(frame: .zero)
	}

	func test_sets_and_gets_command() {
		let vm = ViewModel()
		self.control.command = vm.command
		XCTAssert(self.control.command === vm.command)
	}

	func test_remove_command() {
		let vm = ViewModel()
		self.control.command = vm.command
		self.control.command = nil
		XCTAssert(self.control.command == nil)
	}

	func test_command_do_not_fire_on_subscribe() {
		let vm = ViewModel()
		self.control.command = vm.command
		XCTAssert(vm.invocationsCount == 0)
		XCTAssert(vm.parameter == nil)
	}

	func test_command_fire_on_rise() {
		let vm = ViewModel()
		self.control.command = vm.command
		self.control.command?.execute(parameter: 1)
		XCTAssert(vm.invocationsCount == 1)
		XCTAssert(vm.parameter == 1)
	}

	func test_command_fire_twice_on_double_rise() {
		let vm = ViewModel()
		self.control.command = vm.command
		self.control.command?.execute(parameter: 1)
		self.control.command?.execute(parameter: 2)
		XCTAssert(vm.invocationsCount == 2)
		XCTAssert(vm.parameter == 2)
	}

	func test_command_fire_once_on_subscribe_twice() {
		let vm = ViewModel()
		self.control.command = vm.command
		self.control.command = vm.command
		self.control.command?.execute(parameter: 1)
		XCTAssert(vm.invocationsCount == 1)
		XCTAssert(vm.parameter == 1)
	}

	func test_command_do_not_retain_subscriber() {
		var vm: ViewModel? = ViewModel()
		self.control.command = vm!.command
		let weak = Weak(vm)
		vm = nil
		XCTAssert(weak.isAlive == false)
	}

	func test_command_do_not_fine_on_dead_subscriber() {
		var invocationsCount: Int = 0
		var vm: ViewModel? = ViewModel()
		vm?.command?.onExecute.subscribe(self) {
			_,_ in
			invocationsCount = invocationsCount + 1
		}
		vm = nil
		self.control.command?.execute(parameter: 1)
		XCTAssert(invocationsCount == 0)
	}

}
