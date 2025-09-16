// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

struct PackageMetadata {
	static let version = "2.0.1"
	static let checksum = "2e30e3fc12676ce3c303a7fd330cd868cdde9c567755789ac8f830abea29d411"
}

let package = Package(
	name: "OptOutAdvertisingSDK",
	platforms: [
		.iOS(.v13)
	],
	products: [
		.library(
			name: "OptOutAdvertisingSDK",
			targets: ["OptOutAdvertisingSDK"]
		)
	],
	dependencies: [
		.package(url: "https://github.com/optoutadvertising-com/om-ios-sdk.git", from: "1.5.5")
	],
	targets: [
		.target(
			name: "OptOutAdvertisingSDK",
			dependencies: [
				.target(name: "OptOutAdvertisingSDKBinary"),
				.product(name: "OMSDK_Pinchnl", package: "om-ios-sdk")
			]
		),
		.binaryTarget(
			name: "OptOutAdvertisingSDKBinary",
			url: "https://github.com/optoutadvertising-com/opt-out-ios-sdk/releases/download/\(PackageMetadata.version)/OptOutAdvertisingSDK.xcframework.zip",
			checksum: PackageMetadata.checksum
		)
	]
)
