import XCTest
@testable import SlowContainer
import UIKit

private protocol ISecond : class { }

internal class ContainerTests_Events: XCTestCase {

	private var container: IContainer!

	internal override func setUp() {
		super.setUp()
		self.container = Container()
	}

	// MARK: Events (did resolve)

	internal func test_no_did_resolve_if_no_instance() {
		var count = 0
		self.container
			.register(ITestService.self)
			.withFactory { _ in nil }
			.onDidResolve {
				_,_  in
				count = count + 1
		}
		_ = self.container.resolve(ITestService.self)
		XCTAssert(count == 0)
	}

	internal func test_no_did_resolve_if_no_factory() {
		var count = 0
		self.container
			.register(ITestService.self)
			.onDidResolve {
				_,_  in
				count = count + 1
		}
		_ = self.container.resolve(ITestService.self)
		XCTAssert(count == 0)
	}

	internal func test_did_resolve_if_unable_to_cast_with_as() {
		var count = 0
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.as(ISecond.self)
			.onDidResolve {
				_,_  in
				count = count + 1
		}
		_ = self.container.resolve(ISecond.self)
		XCTAssert(count == 1)
	}

	internal func test_did_resolve_called_on_resolve() {
		var count = 0
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.onDidResolve {
				_,_  in
				count = count + 1
		}
		_ = self.container.resolve(ITestService.self)
		XCTAssert(count == 1)
	}

	internal func test_did_resolve_called_on_each_resolve() {
		var count = 0
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.onDidResolve {
				_,_  in
				count = count + 1
		}
		_ = self.container.resolve(ITestService.self)
		_ = self.container.resolve(ITestService.self)
		XCTAssert(count == 2)
	}

	internal func test_did_resolve_called_on_each_resolve_if_singleton() {
		var count = 0
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.singleInstance()
			.onDidResolve {
				_,_  in
				count = count + 1
		}
		_ = self.container.resolve(ITestService.self)
		_ = self.container.resolve(ITestService.self)
		XCTAssert(count == 2)
	}

	internal func test_did_resolve_returns_resolved_instance() {
		var resolvedService: ITestService?
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.onDidResolve {
				_, instance in
				resolvedService = instance
		}
		let service = self.container.resolve(ITestService.self)!
		XCTAssert(service === resolvedService)
	}

	// MARK: Events (did create)

	internal func test_no_did_create_if_no_instance() {
		var count = 0
		self.container
			.register(ITestService.self)
			.withFactory { _ in nil }
			.onDidCreate {
				_,_  in
				count = count + 1
		}
		_ = self.container.resolve(ITestService.self)
		XCTAssert(count == 0)
	}

	internal func test_no_did_create_if_no_factory() {
		var count = 0
		self.container
			.register(ITestService.self)
			.onDidCreate {
				_,_  in
				count = count + 1
		}
		_ = self.container.resolve(ITestService.self)
		XCTAssert(count == 0)
	}

	internal func test_did_create_if_unable_to_cast_with_as() {
		var count = 0
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.as(ISecond.self)
			.onDidCreate {
				_,_  in
				count = count + 1
		}
		let service = self.container.resolve(ISecond.self)
		XCTAssert(count == 1)
		XCTAssert(service == nil)
	}

	internal func test_did_create_called_on_creation() {
		var count = 0
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.onDidCreate {
				_,_  in
				count = count + 1
		}
		_ = self.container.resolve(ITestService.self)
		XCTAssert(count == 1)
	}

	internal func test_did_create_called_on_each_creation() {
		var count = 0
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.onDidCreate {
				_,_  in
				count = count + 1
		}
		_ = self.container.resolve(ITestService.self)
		_ = self.container.resolve(ITestService.self)
		XCTAssert(count == 2)
	}

	internal func test_did_create_called_once_if_singleton() {
		var count = 0
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.singleInstance()
			.onDidCreate {
				_,_  in
				count = count + 1
		}
		_ = self.container.resolve(ITestService.self)
		_ = self.container.resolve(ITestService.self)
		XCTAssert(count == 1)
	}

	internal func test_did_create_returns_created_instance() {
		var resolvedService: ITestService?
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService() }
			.onDidCreate {
				_, instance in
				resolvedService = instance
		}
		let service = self.container.resolve(ITestService.self)!
		XCTAssert(service === resolvedService)
	}
}
