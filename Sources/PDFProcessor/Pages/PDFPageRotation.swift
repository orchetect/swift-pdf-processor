//
//  PDFPageRotation.swift
//  swift-pdf-processor • https://github.com/orchetect/swift-pdf-processor
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(PDFKit)

import Foundation

/// PDF editing page rotation descriptor.
public struct PDFPageRotation {
    public var angle: Angle
    public var changeBehavior: PDFOperation.ChangeBehavior

    public init(angle: Angle, apply changeBehavior: PDFOperation.ChangeBehavior = .relative) {
        self.angle = angle
        self.changeBehavior = changeBehavior
    }

    public func degrees(offsetting other: Angle = ._0degrees) -> Int {
        switch changeBehavior {
        case .absolute: angle.degrees
        case .relative: (angle + other).degrees
        }
    }
}

extension PDFPageRotation: Equatable { }

extension PDFPageRotation: Hashable { }

extension PDFPageRotation {
    public var verboseDescription: String {
        "\(changeBehavior == .relative ? "by" : "to") \(angle.verboseDescription)"
    }
}

extension PDFPageRotation: Sendable { }

#endif
