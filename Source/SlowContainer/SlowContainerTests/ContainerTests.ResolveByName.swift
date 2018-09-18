import XCTest
@testable import SlowContainer
import UIKit

internal class ContainerTests_ResolveByName: XCTestCase {

	private var container: IContainer!

	internal override func setUp() {
		super.setUp()
		self.container = Container()
	}

	internal func test_resolve_unregistered_instance_by_name_returns_nil() {
		let service = self.container.resolve(TestService.self, name: "name")
		XCTAssert(service == nil)
	}

	internal func test_resolve_by_name_returns_registered_instance() {
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.forName("name")
		let service = self.container.resolve(ITestService.self, name: "name")
		XCTAssert(service != nil)
		XCTAssert(service is TestService)
	}

	internal func test_register_as_singleton_returns_single_instance_by_name() {
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.singleInstance()
			.forName("name")
		let service1 = self.container.resolve(ITestService.self, name: "name")!
		let service2 = self.container.resolve(ITestService.self, name: "name")!
		XCTAssert(service1 === service2)
	}

	internal func test_register_as_singleton_returns_different_instances_for_different_names() {
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.singleInstance()
			.forName("name1")
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.singleInstance()
			.forName("name2")
		let service1 = self.container.resolve(ITestService.self, name: "name1")!
		let service2 = self.container.resolve(ITestService.self, name: "name2")!
		XCTAssert(service1 !== service2)
	}

	internal func test_register_as_per_request_returns_different_instances_by_name() {
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.perRequest()
			.forName("name")
		let service1 = self.container.resolve(ITestService.self, name: "name")!
		let service2 = self.container.resolve(ITestService.self, name: "name")!
		XCTAssert(service1 !== service2)
	}

	internal func test_resolve_by_different_name_returns_nil() {
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.forName("name1")
		let service = self.container.resolve(ITestService.self, name: "name2")
		XCTAssert(service == nil)
	}

	internal func test_new_name_replaces_old_name() {
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.forName("name1")
			.forName("name2")
		let service1 = self.container.resolve(ITestService.self, name: "name1")
		let service2 = self.container.resolve(ITestService.self, name: "name2")
		XCTAssert(service1 == nil)
		XCTAssert(service2 != nil)
	}
}
