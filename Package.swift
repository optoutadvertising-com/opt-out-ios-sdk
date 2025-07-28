// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

struct PackageMetadata {
	static let version = "1.1.5"
	static let checksum = "76a5b91a5da979163540c4411be70050913f3e80ff72c599dd3d7e8d32502387"
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