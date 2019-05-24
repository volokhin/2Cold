import XCTest
import SlowCommon

private class TargetObject : IHaveAssociatedObject { }
private class TestValue { }

class AssociatedObjectsTests: XCTestCase {

	private var targetObject: TargetObject!

	override func setUp() {
		self.targetObject = TargetObject()
	}

	func test_store_string() {
		var key: Int = 0
		self.targetObject.setAssociatedObject("string", for: &key, policy: .strong)
		let result: String? = self.targetObject.associatedObject(for: &key)
		XCTAssert(result == "string")
	}

	func test_store_int() {
		var key: Int = 0
		self.targetObject.setAssociatedObject(42, for: &key, policy: .strong)
		let result: Int? = self.targetObject.associatedObject(for: &key)
		XCTAssert(result == 42)
	}

	func test_store_object_strong() {
		var key: Int = 0
		let object = TestValue()
		self.targetObject.setAssociatedObject(object, for: &key, policy: .strong)
		let result: TestValue? = self.targetObject.associatedObject(for: &key)
		XCTAssert(result === object)
	}

	func test_do_not_get_wrong_type() {
		var key: Int = 0
		self.targetObject.setAssociatedObject(42, for: &key, policy: .strong)
		let result: String? = self.targetObject.associatedObject(for: &key)
		XCTAssert(result == nil)
	}

	func test_do_not_get_value_for_wrong_key() {
		var key: Int = 0
		var wrongKey: Int = 0
		self.targetObject.setAssociatedObject(42, for: &key, policy: .strong)
		let result: Int? = self.targetObject.associatedObject(for: &wrongKey)
		XCTAssert(result == nil)
	}

	func test_store_object_weak() {
		var key: Int = 0
		let object = TestValue()
		self.targetObject.setAssociatedObject(object, for: &key, policy: .weak)
		let result: TestValue? = self.targetObject.associatedObject(for: &key)
		XCTAssert(result === object)
	}

	func test_retain_strong_object() {
		var key: Int = 0
		var dead: TestValue? = TestValue()
		let weak = Weak(dead)
		self.targetObject.setAssociatedObject(dead, for: &key, policy: .strong)
		dead = nil
		let result: TestValue? = self.targetObject.associatedObject(for: &key)
		XCTAssert(result != nil)
		XCTAssert(weak.isAlive == true)
	}

//	func test_do_not_retain_weak_object() {
//		var key: Int = 0
//		var dead: TestValue? = TestValue()
//		let weak = Weak(dead)
//		self.targetObject.setAssociatedObject(dead, for: &key, policy: .weak)
//		dead = nil
//		let result: TestValue? = self.targetObject.associatedObject(for: &key)
//		XCTAssert(result == nil)
//		XCTAssert(weak.isAlive == false)
//	}


}
