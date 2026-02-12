/// Represents any JSON-compatible value with type-safe accessors.
public enum JSONValue: Sendable, Equatable, Hashable {
    case null
    case bool(Bool)
    case int(Int)
    case double(Double)
    case string(String)
    case array([JSONValue])
    case object([String: JSONValue])
}

extension JSONValue: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self = .null
            return
        }
        if let value = try? container.decode(Bool.self) {
            self = .bool(value)
            return
        }
        if let value = try? container.decode(Int.self) {
            self = .int(value)
            return
        }
        if let value = try? container.decode(Double.self) {
            self = .double(value)
            return
        }
        if let value = try? container.decode(String.self) {
            self = .string(value)
            return
        }
        if let value = try? container.decode([JSONValue].self) {
            self = .array(value)
            return
        }
        if let value = try? container.decode([String: JSONValue].self) {
            self = .object(value)
            return
        }

        throw DecodingError.typeMismatch(
            JSONValue.self,
            .init(codingPath: decoder.codingPath, debugDescription: "Unable to decode JSONValue")
        )
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .null:
            try container.encodeNil()
        case .bool(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        case .array(let values):
            try container.encode(values)
        case .object(let object):
            try container.encode(object)
        }
    }
}

// Existing EasyMove compatibility accessors.
extension JSONValue {
    public var string: String? {
        if case .string(let value) = self { return value }
        return nil
    }

    public var object: [String: JSONValue]? {
        if case .object(let value) = self { return value }
        return nil
    }

    public var array: [JSONValue]? {
        if case .array(let value) = self { return value }
        return nil
    }

    public var bool: Bool? {
        if case .bool(let value) = self { return value }
        return nil
    }

    public var int64: Int64? {
        switch self {
        case .int(let value):
            return Int64(exactly: value)
        case .double(let value):
            return Int64(exactly: value)
        case .string(let value):
            return Int64(value)
        default:
            return nil
        }
    }

    public var doubleValue: Double? {
        switch self {
        case .int(let value):
            return Double(value)
        case .double(let value):
            return value
        case .string(let value):
            return Double(value)
        default:
            return nil
        }
    }
}

// GraveInsight compatibility accessors.
extension JSONValue {
    public var asString: String? { string }

    public var asInt: Int? {
        switch self {
        case .int(let value):
            return value
        case .double(let value):
            return Int(exactly: value)
        case .string(let value):
            return Int(value)
        default:
            return nil
        }
    }

    public var asDouble: Double? { doubleValue }

    public var asBool: Bool? { bool }

    public var asArray: [JSONValue]? { array }

    public var asObject: [String: JSONValue]? { object }

    public var isNull: Bool {
        if case .null = self { return true }
        return false
    }
}

extension JSONValue: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension JSONValue: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .int(value)
    }
}

extension JSONValue: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .double(value)
    }
}

extension JSONValue: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .bool(value)
    }
}

extension JSONValue: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: JSONValue...) {
        self = .array(elements)
    }
}

extension JSONValue: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, JSONValue)...) {
        self = .object(Dictionary(uniqueKeysWithValues: elements))
    }
}

extension JSONValue: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .null
    }
}

extension JSONValue {
    public subscript(key: String) -> JSONValue? {
        if case .object(let dictionary) = self {
            return dictionary[key]
        }
        return nil
    }

    public subscript(index: Int) -> JSONValue? {
        if case .array(let values) = self, values.indices.contains(index) {
            return values[index]
        }
        return nil
    }
}
