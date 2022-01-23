// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "CombineHarvesterKit",
  platforms: [.iOS(.v14), .macOS(.v11)],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "CombineHarvesterKit",
      targets: ["CombineHarvesterKit"]
    )
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
//    .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.47.0"), // dev
//    .package(url: "https://github.com/realm/SwiftLint", from: "0.41.0"), // dev
//    .package(url: "https://github.com/shibapm/Komondor", from: "1.0.6"), // dev
//    .package(url: "https://github.com/eneko/SourceDocs", from: "1.2.1"), // dev
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "CombineHarvesterKit",
      dependencies: []
    )
  ]
)

#if canImport(PackageConfig)
  import PackageConfig

  // let requiredCoverage: Int = 1

  let config = PackageConfiguration([
    "rocket": ["steps":
      [
        "hide_dev_dependencies"
      ]],
    "komondor": [
      //      "pre-push": [
//        //"swift test --enable-code-coverage --enable-test-discovery",
//        //"swift run swift-test-codecov .build/debug/codecov/HeartwitchKit.json -v \(requiredCoverage)"
//      ],
      "pre-commit": [
        // "swift test --enable-code-coverage --enable-test-discovery --generate-linuxmain",
        "swift run swiftformat .",
        "swift run swiftlint autocorrect",
        "swift run sourcedocs generate build -cra",
        "git add .",
        "swift run swiftformat --lint .",
        "swift run swiftlint"
      ]
    ]
  ]).write()
#endif
