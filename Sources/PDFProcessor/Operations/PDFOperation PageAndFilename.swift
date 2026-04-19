//
//  PDFOperation PageAndFilename.swift
//  swift-pdf-processor • https://github.com/orchetect/swift-pdf-processor
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(PDFKit)

import Foundation

extension PDFOperation {
    /// PDF editing operation page & filename descriptor.
    public struct PageAndFilename {
        public var pageIndex: Int
        public var filename: String?

        public init(_ pageIndex: Int, _ filename: String? = nil) {
            self.pageIndex = pageIndex
            self.filename = filename
        }
    }
}

extension PDFOperation.PageAndFilename: Equatable { }

extension PDFOperation.PageAndFilename: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.pageIndex < rhs.pageIndex
    }
}

extension PDFOperation.PageAndFilename: Hashable { }

extension PDFOperation.PageAndFilename: Sendable { }

extension PDFOperation.PageAndFilename {
    public var verboseDescription: String {
        if let filename {
            "page index \(pageIndex) with name \(filename.quoted)"
        } else {
            "page index \(pageIndex)"
        }
    }
}

#endif
