import XCTest
@testable import SlowContainer

internal class ContainerTests_ContainsAndUnregister: XCTestCase {

	private var container: IContainer!

	internal override func setUp() {
		super.setUp()
		self.container = Container()
	}

	// MARK: Contains

	internal func test_do_not_contains_unregistered_instance() {
		let contains = self.container.contains(ITestService.self)
		XCTAssert(contains == false)
	}

	internal func test_do_not_contains_unregistered_instance_by_name() {
		self.container.register(ITestService.self)
		let contains = self.container.contains(ITestService.self, name: "name")
		XCTAssert(contains == false)
	}

	internal func test_contains_registered_instance() {
		self.container.register(ITestService.self)
		let contains = self.container.contains(ITestService.self)
		XCTAssert(contains == true)
	}

	internal func test_contains_registered_instance_by_name() {
		self.container.register(ITestService.self).forName("name")
		let contains = self.container.contains(ITestService.self, name: "name")
		XCTAssert(contains == true)
	}

	internal func test_do_not_contains_registered_instance_by_different_name() {
		self.container.register(ITestService.self).forName("name1")
		let contains = self.container.contains(ITestService.self, name: "name2")
		XCTAssert(contains == false)
	}

	internal func test_do_not_contains_after_unregister() {
		self.container.register(ITestService.self)
		self.container.unregister(ITestService.self)
		let contains = self.container.contains(ITestService.self)
		XCTAssert(contains == false)
	}

	internal func test_do_not_contains_after_unregister_by_name() {
		self.container.register(ITestService.self).forName("name")
		self.container.unregister(ITestService.self, name: "name")
		let contains = self.container.contains(ITestService.self)
		XCTAssert(contains == false)
	}

	// MARK: Unregister

	internal func test_unregister_removes_registration() {
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
		self.container.unregister(ITestService.self)
		let service = container.resolve(ITestService.self)
		XCTAssert(service == nil)
	}

	internal func test_unregister_by_name_removes_registration() {
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.forName("name")
		self.container.unregister(ITestService.self, name: "name")
		let service = container.resolve(ITestService.self, name: "name")
		XCTAssert(service == nil)
	}

	internal func test_unregister_by_different_name_do_not_removes_registration() {
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.forName("name1")
		self.container.unregister(ITestService.self, name: "name2")
		let service = container.resolve(ITestService.self, name: "name1")
		XCTAssert(service != nil)
	}
}
