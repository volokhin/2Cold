import XCTest
import SlowCommon
@testable import SlowContainer
import UIKit

internal class ContainerTests_Retaining: XCTestCase {

	private var container: IContainer!

	internal override func setUp() {
		super.setUp()
		self.container = Container()
	}

	internal func test_retain_single_instance() {
		var service: TestService? = TestService()
		let weak = Weak(service!)
		self.container.register(TestService.self)
			.singleInstance()
			.withFactory { _ in service! }
		_ = self.container.resolve(TestService.self)
		service = nil
		XCTAssert(weak.value != nil)
	}

	internal func test_not_retain_per_request_instance() {
		var service: TestService? = TestService()
		let weak = Weak(service!)
		self.container.register(TestService.self)
			.perRequest()
			.withFactory { _ in service! }
		_ = self.container.resolve(TestService.self)
		service = nil
		XCTAssert(weak.value == nil)
	}
}
