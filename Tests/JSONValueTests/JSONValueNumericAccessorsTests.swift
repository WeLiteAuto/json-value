import Testing
@testable import JSONValue

@Suite("JSONValue Numeric Accessors")
struct JSONValueNumericAccessorsTests {
    @Test("int64 returns nil for large finite doubles outside Int64 range")
    func int64ReturnsNilForLargeFiniteDouble() {
        let value = JSONValue.double(1e100)
        #expect(value.int64 == nil)
    }

    @Test("asInt handles floating-point Int boundaries safely")
    func asIntHandlesDoubleIntBoundariesSafely() {
        #expect(JSONValue.double(Double(Int.max)).asInt == nil)
        #expect(JSONValue.double(Double(Int.min)).asInt == Int.min)
    }

    @Test("integer-valued doubles convert when exactly representable")
    func integerValuedDoubleConvertsWhenExact() {
        let value = JSONValue.double(42.0)
        #expect(value.int64 == 42)
        #expect(value.asInt == 42)
    }

    @Test("fractional doubles return nil")
    func fractionalDoubleReturnsNil() {
        let value = JSONValue.double(42.5)
        #expect(value.int64 == nil)
        #expect(value.asInt == nil)
    }

    @Test("non-finite doubles return nil")
    func nonFiniteDoubleReturnsNil() {
        #expect(JSONValue.double(.infinity).int64 == nil)
        #expect(JSONValue.double(-.infinity).int64 == nil)
        #expect(JSONValue.double(.nan).int64 == nil)
        #expect(JSONValue.double(.infinity).asInt == nil)
        #expect(JSONValue.double(-.infinity).asInt == nil)
        #expect(JSONValue.double(.nan).asInt == nil)
    }
}
