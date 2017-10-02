// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OnBoarding_Backend",
    
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "1.0.0"),
         .package(url: "https://github.com/IBM-Swift/CMySQL.git", .upToNextMinor(from: "0.1.0")),
         .package(url: "https://github.com/IBM-Swift/SwiftKueryMySQL.git", .upToNextMinor(from: "0.13.0")),
         .package(url: "https://github.com/Hearst-DD/ObjectMapper.git", from: "2.0.0"),

    ],
    
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "OnBoarding_Backend",
            dependencies: ["Kitura", "SwiftKueryMySQL", "CMySQL", "ObjectMapper"]
        ),
    ]
)
