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
	targets: [
		.binaryTarget(
			name: "OptOutAdvertisingSDK",
			url: "https://github.com/optoutadvertising-com/ios-sdk/releases/download/\(PackageMetadata.version)/OptOutAdvertisingSDK.xcframework.zip",
			checksum: PackageMetadata.checksum
		)
	]
)