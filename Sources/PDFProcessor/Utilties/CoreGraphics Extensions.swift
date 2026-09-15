//
//  CoreGraphics Extensions.swift
//  SwiftPDFProcessor • https://github.com/orchetect/swift-pdf-processor
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(CoreGraphics)

import CoreGraphics
import Foundation

/// Strongly-typed Swift-friendly analogues to CoreGraphics PDF dictionary/array value types.
///
/// Note that a `CGPDFDictionary` typically contains `Parent` keys whose value references a parent dictionary or
/// array. To prevent infinite recursion while parsing, `Parent` keys are discarded from the parsed values.
public enum CGPDFObjectValue {
    case null
    case boolean(Bool)
    case integer(Int)
    case real(Double)
    case name(String)
    case string(String)
    case array([CGPDFObjectValue])
    case dictionary([String: CGPDFObjectValue])
    case stream(CGPDFStreamRef)

    /// Recursively parses a `CGPDFDictionary` object reference and returns a strongly-typed instance of the value.
    /// This method is called internally by the ``CoreGraphics/CGPDFDictionaryRef/parsedCGPDFObjectValues()`` and
    /// ``CoreGraphics/CGPDFArrayRef/parsedCGPDFObjectValues()`` methods.
    public init(name: UnsafePointer<CChar>, objectRef: CGPDFObjectRef, inDict dict: CGPDFDictionaryRef) throws {
        let type = CGPDFObjectGetType(objectRef) // CGPDFObjectType (enum)

        switch type {
        case .null:
            self = .null

        case .boolean:
            var value: CGPDFBoolean?
            guard CGPDFDictionaryGetBoolean(dict, name, &value) else {
                throw PDFProcessorError.runtimeError("Error reading boolean value.")
            }
            guard let value else {
                throw PDFProcessorError.runtimeError("Error reading boolean value.")
            }
            self = .boolean(value != 0)

        case .integer:
            var value: CGPDFInteger = 0
            guard CGPDFDictionaryGetInteger(dict, name, &value) else {
                throw PDFProcessorError.runtimeError("Error reading integer value.")
            }
            self = .integer(Int(value))

        case .real:
            var value: CGPDFReal = 0.0
            guard CGPDFDictionaryGetNumber(dict, name, &value) else {
                throw PDFProcessorError.runtimeError("Error reading real number value.")
            }
            self = .real(Double(value))

        case .name:
            var value: UnsafePointer<CChar>!
            guard CGPDFDictionaryGetName(dict, name, &value) else {
                throw PDFProcessorError.runtimeError("Error reading name value.")
            }
            let string = String(cString: value)
            self = .name(string)

        case .string:
            var value: CGPDFStringRef!
            guard CGPDFDictionaryGetString(dict, name, &value) else {
                throw PDFProcessorError.runtimeError("Error reading string value.")
            }
            let string = try String(pdfStringRef: value)
            self = .string(string)

        case .array:
            var value: CGPDFArrayRef!
            guard CGPDFDictionaryGetArray(dict, name, &value) else {
                throw PDFProcessorError.runtimeError("Error reading string value.")
            }
            let array = try value.parsedCGPDFObjectValues()
            self = .array(array)

        case .dictionary:
            var value: CGPDFDictionaryRef!
            guard CGPDFDictionaryGetDictionary(dict, name, &value) else {
                throw PDFProcessorError.runtimeError("Error reading dictionary value.")
            }
            let dictionary = try value.parsedCGPDFObjectValues()
            self = .dictionary(dictionary)

        case .stream:
            var value: CGPDFStreamRef!
            guard CGPDFDictionaryGetStream(dict, name, &value) else {
                throw PDFProcessorError.runtimeError("Error reading stream value.")
            }
            self = .stream(value)

        @unknown default:
            fatalError("Unhandled CGPDFObjectType.")
        }
    }

    /// Recursively parses a `CGPDFDictionary` object reference and returns a strongly-typed instance of the value.
    /// This method is called internally by the ``CoreGraphics/CGPDFDictionaryRef/parsedCGPDFObjectValues()`` and
    /// ``CoreGraphics/CGPDFArrayRef/parsedCGPDFObjectValues()`` methods.
    public init(index: Int, objectRef: CGPDFObjectRef, inArray array: CGPDFArrayRef) throws {
        let type = CGPDFObjectGetType(objectRef) // CGPDFObjectType (enum)

        switch type {
        case .null:
            guard CGPDFArrayGetNull(array, index) else {
                throw PDFProcessorError.runtimeError("Error reading null value.")
            }
            self = .null

        case .boolean:
            var value: CGPDFBoolean?
            guard CGPDFArrayGetBoolean(array, index, &value) else {
                throw PDFProcessorError.runtimeError("Error reading boolean value.")
            }
            guard let value else {
                throw PDFProcessorError.runtimeError("Error reading boolean value.")
            }
            self = .boolean(value != 0)

        case .integer:
            var value: CGPDFInteger = 0
            guard CGPDFArrayGetInteger(array, index, &value) else {
                throw PDFProcessorError.runtimeError("Error reading integer value.")
            }
            self = .integer(Int(value))

        case .real:
            var value: CGPDFReal = 0.0
            guard CGPDFArrayGetNumber(array, index, &value) else {
                throw PDFProcessorError.runtimeError("Error reading real number value.")
            }
            self = .real(Double(value))

        case .name:
            var value: UnsafePointer<CChar>!
            guard CGPDFArrayGetName(array, index, &value) else {
                throw PDFProcessorError.runtimeError("Error reading name value.")
            }
            let string = String(cString: value)
            self = .name(string)

        case .string:
            var value: CGPDFStringRef!
            guard CGPDFArrayGetString(array, index, &value) else {
                throw PDFProcessorError.runtimeError("Error reading string value.")
            }
            let string = try String(pdfStringRef: value)
            self = .string(string)

        case .array:
            var value: CGPDFArrayRef!
            guard CGPDFArrayGetArray(array, index, &value) else {
                throw PDFProcessorError.runtimeError("Error reading array value.")
            }
            let array = try value.parsedCGPDFObjectValues()
            self = .array(array)

        case .dictionary:
            var value: CGPDFDictionaryRef!
            guard CGPDFArrayGetDictionary(array, index, &value) else {
                throw PDFProcessorError.runtimeError("Error reading dictionary value.")
            }
            let dictionary = try value.parsedCGPDFObjectValues()
            self = .dictionary(dictionary)

        case .stream:
            var value: CGPDFStreamRef!
            guard CGPDFArrayGetStream(array, index, &value) else {
                throw PDFProcessorError.runtimeError("Error reading stream value.")
            }
            self = .stream(value)

        @unknown default:
            fatalError("Unhandled CGPDFObjectType.")
        }
    }
}

extension CGPDFObjectType: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .null: "null"
        case .boolean: "boolean"
        case .integer: "integer"
        case .real: "real"
        case .name: "name"
        case .string: "string"
        case .array: "array"
        case .dictionary: "dictionary"
        case .stream: "stream"
        @unknown default:
            fatalError("Unhandled CGPDFObjectType.")
        }
    }
}

extension CGPDFObjectType: @retroactive CustomDebugStringConvertible {
    public var debugDescription: String {
        description
    }
}

extension CGPDFDictionaryRef {
    /// Converts the `CGPDFDictionaryRef` to a more friendly Swift dictionary with strongly-typed values.
    ///
    /// Note that a `CGPDFDictionary` typically contains `Parent` keys whose value references a parent dictionary or
    /// array. To prevent infinite recursion while parsing, `Parent` keys are discarded from the parsed values.
    public func parsedCGPDFObjectValues() throws -> [String: CGPDFObjectValue] {
        class Info {
            var dict: [String: CGPDFObjectValue] = [:]
            var error: (any Error)? = nil
            init() { }
        }
        let info = Info()

        let infoPtr = Unmanaged.passRetained(info).toOpaque()
        // defer { infoPtr.deallocate() }
        defer { Unmanaged.passUnretained(info).release() }

        CGPDFDictionaryApplyBlock(
            self,
            { name, objectRef, infoPtr in
                let info = Unmanaged<Info>.fromOpaque(infoPtr!).takeUnretainedValue()
                let nameString = String(cString: name)
                guard nameString != "Parent" else { return true } // Parent return a pointer that cause infinite recursion
                do {
                    let value = try CGPDFObjectValue(name: name, objectRef: objectRef, inDict: self)
                    info.dict[nameString] = value
                    return true
                } catch {
                    info.error = error
                    return false
                }
            },
            infoPtr
        )

        if let err = info.error { throw err }

        let output = info.dict
        return output
    }
}

extension CGPDFArrayRef {
    /// Converts the `CGPDFArrayRef` to a more friendly Swift array with strongly-typed values.
    public func parsedCGPDFObjectValues() throws -> [CGPDFObjectValue] {
        class Info {
            var array: [CGPDFObjectValue] = []
            var error: (any Error)? = nil
            init() { }
        }
        let info = Info()

        let infoPtr = Unmanaged.passRetained(info).toOpaque()
        defer { Unmanaged.passUnretained(info).release() }

        CGPDFArrayApplyBlock(
            self,
            { index, objectRef, infoPtr in
                let info = Unmanaged<Info>.fromOpaque(infoPtr!).takeUnretainedValue()
                do {
                    let value = try CGPDFObjectValue(index: index, objectRef: objectRef, inArray: self)
                    info.array.append(value)
                    return true
                } catch {
                    info.error = error
                    return false
                }
            },
            infoPtr
        )

        if let err = info.error { throw err }

        let output = info.array
        return output
    }
}

extension String {
    /// A PDF string object is a series of bytes—unsigned integer values in the range 0 to 255.
    init(pdfStringRef: CGPDFStringRef) throws {
        guard let cfString = CGPDFStringCopyTextString(pdfStringRef) else {
            throw PDFProcessorError.runtimeError("Error reading string value.")
        }
        self = cfString as String
    }
}

extension Date {
    /// The PDF specification defines a specific format for strings that represent dates.
    /// This function converts strings in that form to CFDate objects.
    init(pdfStringRef: CGPDFStringRef) throws {
        guard let cfDate = CGPDFStringCopyDate(pdfStringRef) else {
            throw PDFProcessorError.runtimeError("Error reading date from string value.")
        }
        self = cfDate as Date
    }
}

#endif
