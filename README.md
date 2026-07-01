# OptOutAdvertisingSDK

**Privacy-friendly advertising SDK for iOS (iOS 15+).**

## Features

- GDPR & privacy-friendly opt-out management
- Ad lazy loading for performance
- Minimal integration footprint
- Custom parameters for ad targeting
- Supports TCF strings and consent updates
- Native ad support
- Pre-fetch and cache ad slots

---

## Installation

**Swift Package Manager**

Add via **Xcode > Add Package Dependencies** using:

```
https://github.com/optoutadvertising-com/ios-sdk
```

**CocoaPods**

Add to your `Podfile`:

```ruby
pod 'OptOutAdvertisingSDK'
```

Then run:

```bash
pod install
```

---

## Usage

### Initialize the SDK

Call `initialize` once at app launch (e.g. in `AppDelegate` or your app's entry point). It throws when you try to initialize it twice.

```swift
import OptOutAdvertisingSDK

do {
    try OptOutAdvertising.shared.initialize(
        publisherId: "your_publisher_id",
        lazyLoadOffset: 300, // pixels before ad enters screen bounds, default: 200
        gpsEnabled: true     // whether GPS location may be included in ad requests
    )
} catch {
    print("SDK init failed:", error)
}
```

---

### Update Transparency and Consent (GDPR)

If GDPR applies, update the SDK with the user's consent state and TCF string:

```swift
// async/await
try await OptOutAdvertising.shared.updateTransparencyAndConsent(
    isGdprRequired: true,
    tcfString: "COtybn4Otybn4ABABBENAPCgAAAAAAAAAAAEAAAAA"
)

// completion handler
OptOutAdvertising.shared.updateTransparencyAndConsent(
    isGdprRequired: true,
    tcfString: "COtybn4Otybn4ABABBENAPCgAAAAAAAAAAAEAAAAA"
) { error in
    if let error { print("Consent update failed:", error) }
}
```

---

### Display an Ad (UIKit)

```swift
let adView = OptOutAdView.make()

// Optional sizing controls (set before configure)
adView.maxSize = CGSize(width: 320, height: 250)
adView.doNotResizeToView = false
adView.onSizeChangedCallback = { newSize in
    print("Ad size updated:", newSize)
}

// Configure with an ad slot
adView.configure(adSlot: AdSlot(adslot: "your_ad_slot"))

// Load ad
Task {
    do {
        let adDetail = try await adView.loadAd()
        print("Ad loaded:", adDetail.adSlotName)
    } catch {
        print("Failed to load ad:", error)
    }
}
```

Completion handler variant:

```swift
adView.loadAd { result in
    switch result {
    case .success(let adDetail): print("Ad loaded:", adDetail.adSlotName)
    case .failure(let error): print("Failed:", error)
    }
}
```

---

### Display an Ad (SwiftUI)

```swift
OptOutAd(
    adSlot: AdSlot(adslot: "your_ad_slot"),
    maxSize: CGSize(width: 320, height: 250),
    adDetail: nil,
    onLoad: { adDetail in print("Loaded:", adDetail.adSlotName) },
    onError: { error in print("Error:", error) },
    onSizeUpdate: { size in print("Size:", size) }
)
```

---

### Native Ads (UIKit)

```swift
let nativeAdView = OptOutNativeAdView.make()

// Provide a factory that turns NativeAdContent ([String: String]) into a UIView
nativeAdView.viewFactory = { content in
    let label = UILabel()
    label.text = content["title"]
    return label
}

nativeAdView.configure(adSlot: AdSlot(adslot: "your_native_slot"))

Task {
    do {
        let adDetail = try await nativeAdView.loadAd { url in
            UIApplication.shared.open(url)
        }
        print("Native ad loaded:", adDetail.adSlotName)
    } catch {
        print("Failed:", error)
    }
}
```

### Native Ads (SwiftUI)

> **Note:** SwiftUI native ads require iOS 16+.

```swift
OptOutNativeAd(
    adSlot: AdSlot(adslot: "your_native_slot"),
    onLoad: { adDetail in print("Loaded") },
    onError: { error in print("Error:", error) },
    viewFactory: { content in
        Text(content["title"] ?? "")
    },
    tapHandler: { url in
        UIApplication.shared.open(url)
    }
)
```

---

### Pre-fetching Ad Slots

Register slots upfront so all ad details are cached with the first request:

```swift
let slots = [
    AdSlot(adslot: "slot_a"),
    AdSlot(adslot: "slot_b")
]
try await OptOutAdvertising.shared.registerMultipleAdSlots(adSlots: slots)
```

Display a pre-fetched ad without a network round-trip:

```swift

let adDetail = try await OptOutAdvertising.shared.loadAd(adSlot: AdSlot(adslot: "slot_a"))

// UIKit
await adView.setAd(adDetail: adDetail)

// SwiftUI
OptOutAd(adSlot: AdSlot(adslot: "slot_a"), adDetail: adDetail)
```

---

### Custom Parameters

Pass targeting parameters via the `AdSlot` initializer:

```swift
let slot = AdSlot(
    adslot: "your_ad_slot",
    customParams: [
        "interests": "sports",
        "user_age": "30"
    ]
)
```

---

### GPS

GPS location data is opt-in. Control it at initialization or toggle at runtime:

```swift
try OptOutAdvertising.shared.enableGPSServices(true)
```

---

### Debug / Testing

Use the reserved slot name `"debug"` to load a local test ad without a network request:

```swift
adView.configure(adSlot: AdSlot(adslot: "debug"))
```

---

## License

https://optoutadvertising.com/sdk-license

---

## Contact

https://optoutadvertising.com

---

## Migration Guide — v2 → v3

### Initialization

The SDK is now a singleton with an instance method that throws. The `environment` parameter has been removed; `gpsEnabled` is required.

```swift
// v2
OptOutAdvertising.initialize(
    publisherId: "id",
    environment: .adScience,
    lazyLoadOffset: 300
)

// v3
try OptOutAdvertising.shared.initialize(
    publisherId: "id",
    lazyLoadOffset: 300,
    gpsEnabled: true
)
```

### AdSlot

The `name` property and initializer label have been renamed to `adslot`.

```swift
// v2
AdSlot(name: "slot_name", customParams: [...])

// v3
AdSlot(adslot: "slot_name", customParams: [...])
```

### AdDetail property names

```swift
// v2
adDetail.adSlot     // String
adDetail.nativeData // NativeAdDetail? ([String: String])

// v3
adDetail.adSlotName    // AdSlotName (String)
adDetail.nativeContent // NativeAdContent? ([String: String])
```

A new `adDetail.isNative: Bool` computed property is available.

### OptOutAdView (UIKit)

Use the factory method. `maxSize` and `doNotResizeToView` are now properties set before `configure`. `configure` takes an `AdSlot` object. `loadAd` is async/await.

```swift
// v2
let adView = OptOutAdView()
adView.configure(adSlot: "slot_name", maxSize: CGSize(width: 250, height: 250))
adView.loadAd { adDetail in ... } failedHandler: { error in ... }
adView.setOnHeightChangedListener { height in ... }

// v3
let adView = OptOutAdView.make()
adView.maxSize = CGSize(width: 250, height: 250)
adView.onSizeChangedCallback = { size in ... }
adView.configure(adSlot: AdSlot(adslot: "slot_name"))
let adDetail = try await adView.loadAd()
```

### Custom parameters

`addCustomParam` / `removeCustomParam` are removed. Pass custom params via `AdSlot`:

```swift
// v2
adView.addCustomParam(key: "interests", value: "sports")

// v3
AdSlot(adslot: "slot_name", customParams: ["interests": "sports"])
```

### GDPR consent update

`updateTransparencyAndConsent` is now async and throws.

```swift
// v2
OptOutAdvertising.updateTransparencyAndConsent(isGdprRequired: true, tcfString: "...")

// v3
try await OptOutAdvertising.shared.updateTransparencyAndConsent(isGdprRequired: true, tcfString: "...")
```

### Removed

| Removed | Replacement |
|---|---|
| `environment` init parameter | (not configurable in v3) |
| `OptOutAdvertising.initialize(…)` static | `OptOutAdvertising.shared.initialize(…)` |
| `AdDetail.nativeData` | `AdDetail.nativeContent` |
| `typealias NativeAdDetail` | `typealias NativeAdContent` |
| `adView.addCustomParam(key:value:)` | `AdSlot(customParams:)` |
| `adView.removeCustomParam(key:)` | `AdSlot(customParams:)` |
| `adView.setOnHeightChangedListener` | `adView.onSizeChangedCallback` (now `CGSize`) |
