//
//  PDFTextPageBreak.swift
//  swift-pdf-processor • https://github.com/orchetect/swift-pdf-processor
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(PDFKit)

import Foundation

/// Character(s) to insert at PDF page breaks in plain text output.
public enum PDFTextPageBreak: String {
    case none = ""
    case newLine = "\n"
    case doubleNewLine = "\n\n"
}

extension PDFTextPageBreak: Equatable { }

extension PDFTextPageBreak: Hashable { }

extension PDFTextPageBreak: Sendable { }

extension PDFTextPageBreak {
    public var verboseDescription: String {
        switch self {
        case .none:
            "none"
        case .newLine:
            "new-line"
        case .doubleNewLine:
            "double new-line"
        }
    }
}

#endif
