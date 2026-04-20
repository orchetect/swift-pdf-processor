//
//  PDFFileDescriptor.swift
//  swift-pdf-processor • https://github.com/orchetect/swift-pdf-processor
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(PDFKit)

import Foundation
import PDFKit

/// Criteria to match a single PDF file.
public enum PDFFileDescriptor { // TODO: refactor as protocol
    /// First file.
    case first

    /// Second file.
    case second

    /// Last file.
    case last

    /// File with given index (0-based).
    case index(_ idx: Int)

    /// File matching given filename descriptor.
    case filename(_ filenameDescriptor: PDFFilenameDescriptor)

    /// File matching against an introspection closure.
    case introspecting(_ introspection: PDFFileIntrospection) // TODO: convert to required protocol method
}

extension PDFFileDescriptor: Equatable { }

extension PDFFileDescriptor: Hashable { }

extension PDFFileDescriptor: Sendable { }

extension PDFFileDescriptor {
    func first(in inputs: [PDFFile]) -> PDFFile? {
        switch self {
        case .first:
            return inputs.first

        case .second:
            guard inputs.count > 1 else { return nil }
            return inputs[1]

        case .last:
            return inputs.last

        case let .index(idx):
            guard inputs.indices.contains(idx) else { return nil }
            return inputs[idx]

        case let .filename(filenameDescriptor):
            return inputs.first { pdf in
                filenameDescriptor.matches(pdf.filenameForMatching)
            }

        case let .introspecting(introspection):
            return inputs.first(where: { introspection.closure($0.doc) })
        }
    }
}

extension PDFFileDescriptor {
    public var verboseDescription: String {
        switch self {
        case .first:
            "first file"
        case .second:
            "second file"
        case .last:
            "last file"
        case let .index(idx):
            "file with index \(idx)"
        case let .filename(filenameDescriptor):
            "file with filename \(filenameDescriptor.verboseDescription)"
        case let .introspecting(introspection):
            "file matching \(introspection.description)"
        }
    }
}

#endif
