import XCTest
@testable import SlowContainer
import UIKit

private protocol IServiceWithParameter { }
private class ServiceWithParameter : IServiceWithParameter {
	internal let parameter: ITestService
	internal init(parameter: ITestService) {
		self.parameter = parameter
	}
}

private class ServiceWithNoEmptyInit { }
private class ServiceWithEmptyInit : IHaveEmptyInit {
	internal required init() { }
}

internal class ContainerTests_SimpleResolve: XCTestCase {

	private var container: IContainer!

	internal override func setUp() {
		super.setUp()
		self.container = Container()
	}

	internal func test_resolve_unregistered_instance_returns_nil() {
		let service = self.container.resolve(ITestService.self)
		XCTAssert(service == nil)
	}

	internal func test_resolve_instance_without_factory_returns_nil() {
		self.container.register(ITestService.self)
		let service = self.container.resolve(ITestService.self)
		XCTAssert(service == nil)
	}

	internal func test_resolve_returns_instance_with_empty_init() {
		self.container.register(ServiceWithEmptyInit.self)
		let service = self.container.resolve(ServiceWithEmptyInit.self)
		XCTAssert(service != nil)
	}

	internal func test_resolve_factory_has_precedence_over_empty_init() {
		self.container.register(ServiceWithEmptyInit.self).withFactory { _ in nil }
		let service = self.container.resolve(ServiceWithEmptyInit.self)
		XCTAssert(service == nil)
	}

	internal func test_resolve_returns_nil_if_no_empty_init() {
		self.container.register(ServiceWithNoEmptyInit.self)
		let service = self.container.resolve(ServiceWithNoEmptyInit.self)
		XCTAssert(service == nil)
	}

	internal func test_resolve_returns_registered_instance_with_factory() {
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
		let service = self.container.resolve(ITestService.self)
		XCTAssert(service != nil)
		XCTAssert(service is TestService)
	}

	internal func test_resolve_returns_registered_instance_with_init() {
		self.container
			.register(ITestService.self)
			.withInit(TestService.init)
		let service = self.container.resolve(ITestService.self)
		XCTAssert(service != nil)
		XCTAssert(service is TestService)
	}

	internal func test_resolve_returns_registered_instance_with_init_with_parameter() {
		self.container.register(ITestService.self).withInit(TestService.init)
		self.container.register(IServiceWithParameter.self).withInit(ServiceWithParameter.init)
		let service = self.container.resolve(IServiceWithParameter.self)
		XCTAssert(service != nil)
		XCTAssert(service is ServiceWithParameter)
	}

	internal func test_register_as_singleton_returns_single_instance() {
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.singleInstance()
		let service1 = self.container.resolve(ITestService.self)!
		let service2 = self.container.resolve(ITestService.self)!
		XCTAssert(service1 === service2)
	}

	internal func test_register_as_per_request_returns_different_instances() {
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.perRequest()
		let service1 = self.container.resolve(ITestService.self)!
		let service2 = self.container.resolve(ITestService.self)!
		XCTAssert(service1 !== service2)
	}

	internal func test_by_default_returns_different_instances() {
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
		let service1 = self.container.resolve(ITestService.self)!
		let service2 = self.container.resolve(ITestService.self)!
		XCTAssert(service1 !== service2)
	}

	internal func test_single_instance_replaces_per_request() {
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.perRequest()
			.singleInstance()
		let service1 = self.container.resolve(ITestService.self)!
		let service2 = self.container.resolve(ITestService.self)!
		XCTAssert(service1 === service2)
	}

	internal func test_per_request_replaces_single_instance() {
		self.container
			.register(ITestService.self)
			.withFactory {
				_ in TestService()

			}
			.singleInstance()
			.perRequest()
		let service1 = self.container.resolve(ITestService.self)!
		let service2 = self.container.resolve(ITestService.self)!
		XCTAssert(service1 !== service2)
	}

	internal func test_new_factory_replaces_old_factory() {
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService1() }
			.withFactory { _ in TestService2() }
			.singleInstance()
		let service = self.container.resolve(ITestService.self)!
		XCTAssert(service is TestService2)
	}
}
