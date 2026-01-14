// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

struct PackageMetadata {
	static let version = "2.1.0"
	static let checksum = "cd04aa16c8d385234c34dbbe6da44c874f46156a625e025a3fc5ac72a854f80a"
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
