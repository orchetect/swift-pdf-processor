# swift-pdf-processor

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Forchetect%2Fswift-pdf-processor%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/orchetect/swift-pdf-processor) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Forchetect%2Fswift-pdf-processor%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/orchetect/swift-pdf-processor) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/swift-pdf-processor/blob/main/LICENSE)

Batch PDF utilities with simple API for Swift. Declarative API for:

- assigning or removing file attributes (metadata)
- file filtering, ordering, and merging
- page management: reordering, collation, copying, moving, and replacement
- page presentation: rotation, cropping, etc.
- page content: filtering, removal or burn-in of annotations, removal of file protections

## Installation

### Swift Package Manager (SPM)

To add this package to an Xcode app project, use:

 `https://github.com/orchetect/swift-pdf-processor` as the URL.

To add this package to a Swift package, add the dependency to your package and target in Package.swift:

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/orchetect/swift-pdf-processor", from: "0.3.0")
    ],
    targets: [
        .target(
            dependencies: [
                .product(name: "PDFProcessor", package: "swift-pdf-processor")
            ]
        )
    ]
)
```

## Basic Usage

```swift
import PDFProcessor

let sources = [URL, URL, URL, ...] // URLs to one or more PDF files
let outputDir = URL.desktopDirectory
```

The steps of loading source PDFs, performing operations, and saving the resulting PDFs can be performed individually:

```swift
let processor = PDFProcessor()

try processor.load(pdfs: sources)
try processor.perform(operations: [
    // one or more operations
])

// access the resulting PDF documents in memory
processor.pdfDocuments // [PDFDocument]

// or save them as PDF files to disk
try processor.savePDFs(outputDir: outputDir)
```

Or a fully automated batch operation can be run with a single call to `run()` by passing in a populated instance of `PDFProcessor.Settings`.

```swift
let settings = try PDFProcessor.Settings(
    sourcePDFs: sources,
    outputDir: outputDir,
    operations: [
        // one or more operations
    ],
    savePDFs: true
)

try PDFProcessor().run(using: settings)
```

## Batch Operations

The following are single operations that may be used in a batch sequence of operations.

> [!NOTE]
> More operations may be added in future on an as-needed basis.

### File Operations

- New empty file
- Clone file
- Filter files
- Merge files
- Set file filename(s)
- Set or remove file attributes (metadata such as title, author, etc.)
- Remove file protections (encryption and permissions)

### Page Operations

- Filter pages
- Copy pages
- Move pages
- Replace pages by copying or moving them
- Reverse page order (all or subset of pages)
- Rotate pages
- Crop pages
- Split file into multiple files

### Page Content Operations

- Filter annotations (by types, or remove all)
- Burn in annotations
- Extract plain text (to system pasteboard, to file on disk, or to variable in memory)

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](/LICENSE) for details.

## Sponsoring

If you enjoy using swift-pdf-processor and want to contribute to open-source financially, GitHub sponsorship is much appreciated. Feedback and code contributions are also welcome.

## Community & Support

Please do not email maintainers for technical support. Several options are available for issues and questions:

- Questions and feature ideas can be posted to [Discussions](https://github.com/orchetect/swift-pdf-processor/discussions).
- If an issue is a verifiable bug with reproducible steps it may be posted in [Issues](https://github.com/orchetect/swift-pdf-processor/issues).

## Contributions

Contributions are welcome. Posting in [Discussions](https://github.com/orchetect/swift-pdf-processor/discussions) first prior to new submitting PRs for features or modifications is encouraged.

## Code Quality & AI Contribution Policy

In an effort to maintain a consistent level of code quality and safety, this repository was built by hand and is maintained without the use of AI code generation.

AI-assisted contributions are welcome, but must remain modest in scope, maintain the same degree of quality and care, and be thoroughly vetted before acceptance.

## Legacy

This repository was formerly known as PDFGadget.
