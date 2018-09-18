import XCTest
@testable import SlowContainer
import UIKit

private protocol IFirst : class { }
private protocol ISecond : class { }
private class ServiceWithManyProtocols : IFirst, ISecond { }

internal class ContainerTests_RegisterAs: XCTestCase {

	private var container: IContainer!

	internal override func setUp() {
		super.setUp()
		self.container = Container()
	}

	internal func test_resolve_instance_without_as_returns_nil() {
		self.container.register().withFactory { _  in TestService() }
		let service = self.container.resolve(TestService.self)
		XCTAssert(service == nil)
	}

	internal func test_register_as_returns_nil_if_service_not_conforms_to_protocol() {
		self.container
			.register()
			.withFactory { _ in ServiceWithManyProtocols() }
			.as(ITestService.self)
		let service = self.container.resolve(ITestService.self)
		XCTAssert(service == nil)
	}

	internal func test_register_as_returns_registered_instance() {
		self.container
			.register()
			.withFactory { _ in TestService() }
			.as(ITestService.self)
		let service = self.container.resolve(ITestService.self)
		XCTAssert(service != nil)
		XCTAssert(service is TestService)
	}

	internal func test_register_as_still_returns_original_type() {
		self.container
			.register(IFirst.self)
			.withFactory { _ in ServiceWithManyProtocols() }
			.as(ISecond.self)
		let service = self.container.resolve(IFirst.self)
		XCTAssert(service != nil)
	}

	internal func test_register_as_several_protocols_returns_registered_instance() {
		self.container
			.register()
			.withFactory { _ in ServiceWithManyProtocols() }
			.as(IFirst.self)
			.as(ISecond.self)
		let service1 = self.container.resolve(IFirst.self)
		let service2 = self.container.resolve(ISecond.self)
		XCTAssert(service1 != nil)
		XCTAssert(service2 != nil)
	}

	internal func test_register_as_several_protocols_returns_single_instance_if_specified() {
		self.container
			.register()
			.withFactory { _ in ServiceWithManyProtocols() }
			.as(IFirst.self)
			.as(ISecond.self)
			.singleInstance()
		let service1 = self.container.resolve(IFirst.self)!
		let service2 = self.container.resolve(ISecond.self)!
		XCTAssert(service1 === service2)
	}

	internal func test_register_as_several_protocols_returns_different_instances_if_specified() {
		self.container
			.register()
			.withFactory { _ in ServiceWithManyProtocols() }
			.as(IFirst.self)
			.as(ISecond.self)
			.perRequest()
		let service1 = self.container.resolve(IFirst.self)!
		let service2 = self.container.resolve(ISecond.self)!
		XCTAssert(service1 !== service2)
	}
}
