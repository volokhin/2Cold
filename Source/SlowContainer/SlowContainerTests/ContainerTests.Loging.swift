import XCTest
@testable import SlowContainer
import UIKit

internal class ContainerTests_Loging: XCTestCase {

	private var container: IContainer!
	private var log: LogMock!

	internal override func setUp() {
		super.setUp()
		self.log = LogMock()
		Logger.initialize(log: self.log)
		self.container = Container()
	}

	internal func test_log_unregistered_instance_warning() {
		_ = self.container.resolve(ITestService.self)
		XCTAssert(self.log.lastWarning == """
			Entry for key 'ITestService' is not registered in the container.
			""")
	}

	internal func test_no_factory_warning() {
		self.container.register(ITestService.self)
		_ = self.container.resolve(ITestService.self)
		XCTAssert(self.log.lastWarning == """
			Unable to create an instance of 'ITestService' type. The type does not conform to IHaveEmptyInit and no
			factory or init declatation is specified in the Container.
			""")
	}

	internal func test_log_unable_to_cast_warning() {
		self.container.register().as(TestService1.self).withFactory { _ in TestService() }
		_ = self.container.resolve(TestService1.self)
		XCTAssert(self.log.lastWarning == """
			Unable to cast an instance of type 'TestService' to the type 'TestService1'.
			""")
	}

	internal func test_log_no_warning_if_instance_nil() {
		self.container.register().as(TestService1.self).withFactory { _ in nil }
		_ = self.container.resolve(TestService1.self)
		XCTAssert(self.log.lastWarning == "")
	}

	internal func test_log_new_factory_warning() {
		self.container
			.register(ITestService.self)
			.withFactory { _ in TestService1() }
			.withFactory { _ in TestService2() }
		XCTAssert(self.log.lastWarning == """
			Factory '(IResolver) -> Optional<ITestService>' for a container instance 'ITestService' has already been specified.
			It will be replaced by the new factory. Consider removing redundant factory declaration.
			""")
	}

	internal func test_log_new_init_warning() {
		self.container
			.register(ITestService.self)
			.withInit(TestService.init)
			.withInit(TestService.init)
		XCTAssert(self.log.lastWarning == """
			Factory '(IResolver) -> Optional<ITestService>' for a container instance 'ITestService' has already been specified.
			It will be replaced by the new factory. Consider removing redundant factory declaration.
			""")
	}

	internal func test_log_new_name_warning() {
		self.container
			.register(ITestService.self)
			.forName("name1")
			.forName("name2")
		XCTAssert(self.log.lastWarning == """
			Name 'name1' for a container instance 'ITestService' has already been specified.
			It will be replaced by the new name 'name2'. Consider removing redundant name declaration.
			""")
	}

	internal func test_redundant_singleton_warning() {
		self.container
			.register(ITestService.self)
			.singleInstance()
			.singleInstance()
		XCTAssert(self.log.lastWarning == """
			Instance scoupe 'singleInstance' for a container instance 'ITestService' has already been specified.
			It will be replaced by the new scope 'singleInstance'. Consider removing redundant scope declaration.
			""")
	}

	internal func test_redundant_per_request_warning() {
		self.container
			.register(ITestService.self)
			.perRequest()
			.perRequest()
		XCTAssert(self.log.lastWarning == """
			Instance scoupe 'instancePerRequest' for a container instance 'ITestService' has already been specified.
			It will be replaced by the new scope 'instancePerRequest'. Consider removing redundant scope declaration.
			""")
	}
}
