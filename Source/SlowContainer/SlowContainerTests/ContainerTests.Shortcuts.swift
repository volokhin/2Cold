import XCTest
@testable import SlowContainer
import UIKit

internal class ContainerTests_Shortcuts: XCTestCase {

	private var container: IContainer!

	internal override func setUp() {
		super.setUp()
		self.container = Container()
	}

	internal func test_shortcut_register() {
		self.container.register(ITestService.self) {
			_ in
			TestService()
		}
		let service = self.container.resolve(ITestService.self)
		XCTAssert(service != nil)
		XCTAssert(service is TestService)
	}

	internal func test_shortcut_register_per_request() {
		self.container.registerPerRequest(ITestService.self) {
			_ in
			TestService()
		}
		let service1 = self.container.resolve(ITestService.self)!
		let service2 = self.container.resolve(ITestService.self)!
		XCTAssert(service1 !== service2)
	}

	internal func test_shortcut_register_singleton() {
		self.container.registerSingleton(ITestService.self) {
			_ in
			TestService()
		}
		let service1 = self.container.resolve(ITestService.self)!
		let service2 = self.container.resolve(ITestService.self)!
		XCTAssert(service1 === service2)
	}
}
