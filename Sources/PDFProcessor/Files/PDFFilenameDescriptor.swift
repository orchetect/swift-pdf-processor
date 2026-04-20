//
//  PDFFilenameDescriptor.swift
//  swift-pdf-processor • https://github.com/orchetect/swift-pdf-processor
//  © 2026 Steffan Andrews • Licensed under MIT License
//

internal import SwiftExtensions
import Foundation

/// Criteria to match a PDF filename (excluding .pdf file extension).
public enum PDFFilenameDescriptor { // TODO: refactor as protocol
    /// Exact full string match.
    case equals(String)

    /// Filename that starts with the given string.
    case starts(with: String)

    /// Filename that ends with the given string.
    case ends(with: String)

    /// Filename that contains the given string.
    case contains(String)

    /// Filename that does not start with the given string.
    case doesNotStart(with: String)

    /// Filename that does not end with the given string.
    case doesNotEnd(with: String)

    /// Filename that does not contain the given string.
    case doesNotContain(String)

    // case matches(regex: Regex) // TODO: implement

    // case doesNotMatch(regex: Regex) // TODO: implement
}

extension PDFFilenameDescriptor: Equatable { }

extension PDFFilenameDescriptor: Hashable { }

extension PDFFilenameDescriptor: Sendable { }

extension PDFFilenameDescriptor {
    // TODO: make required protocol method of `PDFFilenameDescriptor`
    public func matches(_ source: String) -> Bool {
        switch self {
        case let .equals(string):
            source == string
        case let .starts(prefix):
            source.starts(with: prefix)
        case let .ends(suffix):
            source.hasSuffix(suffix)
        case let .contains(string):
            source.contains(string)
        case let .doesNotStart(prefix):
            !source.starts(with: prefix)
        case let .doesNotEnd(suffix):
            !source.hasSuffix(suffix)
        case let .doesNotContain(string):
            !source.contains(string)
        }
    }
}

extension PDFFilenameDescriptor {
    public var verboseDescription: String {
        switch self {
        case let .equals(string):
            string.quoted
        case let .starts(prefix):
            "starting with \(prefix.quoted)"
        case let .ends(suffix):
            "ending with \(suffix.quoted)"
        case let .contains(string):
            "containing \(string.quoted)"
        case let .doesNotStart(prefix):
            "not starting with \(prefix.quoted)"
        case let .doesNotEnd(suffix):
            "not ending with \(suffix.quoted)"
        case let .doesNotContain(string):
            "not containing \(string.quoted)"
        }
    }
}
