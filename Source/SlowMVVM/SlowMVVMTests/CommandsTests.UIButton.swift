import XCTest
@testable import SlowMVVM
import SlowCommon

private class ViewModel {
	var invocationsCount: Int = 0
	var command: Command<Void>? = nil
	init() {
		self.command = Command(self) {
			this in
			this.invocationsCount = this.invocationsCount + 1
		}
	}
}

internal class CommandsTests_UIButton: XCTestCase {

	private var button: UIButton!

	internal override func setUp() {
		super.setUp()
		self.button = UIButton(frame: .zero)
	}

	func test_sets_and_gets_command() {
		let vm = ViewModel()
		self.button.command = vm.command
		XCTAssert(self.button.command === vm.command)
	}

	func test_remove_command() {
		let vm = ViewModel()
		self.button.command = vm.command
		self.button.command = nil
		XCTAssert(self.button.command == nil)
	}

	func test_command_do_not_fire_on_subscribe() {
		let vm = ViewModel()
		self.button.command = vm.command
		XCTAssert(vm.invocationsCount == 0)
	}

	func test_command_fire_on_rise() {
		let vm = ViewModel()
		self.button.command = vm.command
		self.button.command?.execute(parameter: ())
		XCTAssert(vm.invocationsCount == 1)
	}

	func test_command_fire_twice_on_double_rise() {
		let vm = ViewModel()
		self.button.command = vm.command
		self.button.command?.execute(parameter: ())
		self.button.command?.execute(parameter: ())
		XCTAssert(vm.invocationsCount == 2)
	}

	func test_command_fire_once_on_subscribe_twice() {
		let vm = ViewModel()
		self.button.command = vm.command
		self.button.command = vm.command
		self.button.command?.execute(parameter: ())
		XCTAssert(vm.invocationsCount == 1)
	}

	func test_command_do_not_retain_subscriber() {
		var vm: ViewModel? = ViewModel()
		self.button.command = vm!.command
		let weak = Weak(vm)
		vm = nil
		XCTAssert(weak.isAlive == false)
	}

	func test_command_do_not_fine_on_dead_subscriber() {
		var invocationsCount: Int = 0
		var vm: ViewModel? = ViewModel()
		vm?.command?.onExecute.subscribe(self) {
			_ in
			invocationsCount = invocationsCount + 1
		}
		vm = nil
		self.button.command?.execute(parameter: ())
		XCTAssert(invocationsCount == 0)
	}
	

}
