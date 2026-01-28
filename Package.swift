// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

struct PackageMetadata {
	static let version = "2.2.0"
	static let checksum = "8df01c5a2d77f7c0c0c0c0d101ac99a9ba395e1d3f48b4c9f50f3242fe475943"
}

let package = Package(
	name: "OptOutAdvertisingSDK",
	platforms: [
		.iOS(.v13)
	],
	products: [
		.library(
			name: "OptOutAdvertising",
			targets: ["OptOutAdvertising"]
		)
	],
	dependencies: [
		.package(url: "https://github.com/optoutadvertising-com/om-ios-sdk.git", from: "1.5.5")
	],
	targets: [
		.target(
			name: "OptOutAdvertising",
			dependencies: [
				.target(name: "OptOutAdvertisingSDKBinary"),
				.product(name: "OMSDK_Pinchnl", package: "om-ios-sdk")
			],
			path: "Sources/OptOutAdvertisingSDK"
		),
		.binaryTarget(
			name: "OptOutAdvertisingSDKBinary",
			url: "https://github.com/optoutadvertising-com/opt-out-ios-sdk/releases/download/\(PackageMetadata.version)/OptOutAdvertisingSDK.xcframework.zip",
			checksum: PackageMetadata.checksum
		)
	]
)
