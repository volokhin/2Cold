import Foundation
import XCTest
import SlowCommon
@testable import SlowMVVM

internal class ViewControllerTests: XCTestCase {

	internal func test_no_retain_circle_if_sets_vm() {

		var vc: TestViewController? = TestViewController()
		var vm: TestViewModel? = TestViewModel()
		let weakVc: Weak<TestViewController> = Weak(value: vc!)
		let weakVm: Weak<TestViewModel> = Weak(value: vm!)

		vc = nil
		vm = nil

		XCTAssert(weakVc.value == nil)
		XCTAssert(weakVm.value == nil)
	}
}
