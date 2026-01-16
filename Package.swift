// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

struct PackageMetadata {
	static let version = "2.1.1"
	static let checksum = "9b626cc5046ba2c1a3d0f650334f65f20b9c7b1acd3d7baf99b6fb6720a458fc"
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
