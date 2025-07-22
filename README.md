# OptOutAdvertisingSDK

**Privacy-friendly advertising SDK for iOS (iOS 13+).**

## Features

- GDPR & privacy-friendly opt-out management
- Ad lazy loading for performance
- Minimal integration footprint
- Custom parameters for ad targeting
- Supports TCF strings and consent updates

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

```swift
import OptOutAdvertisingSDK

// Basic initialization
OptOutAdvertising.initialize(
    publisherId: "your_publisher_id"
)

// Advanced initialization with environment and lazy load offset
OptOutAdvertising.initialize(
    publisherId: "your_publisher_id",
    environment: .adScience,
    lazyLoadOffset: 300 // pixels before ad enters screen bounds
)
```

---

### Update Transparency and Consent (GDPR)

If GDPR applies, update the SDK with the user's consent state and TCF string:

```swift
OptOutAdvertising.updateTransparencyAndConsent(
    isGdprRequired: true,
    tcfString: "COtybn4Otybn4ABABBENAPCgAAAAAAAAAAAEAAAAA"
)
```

---

### Load an Ad in Your View

```swift
let adView = OptOutAdView()

// Configure with ad slot and optional max size
adView.configure(
	adSlot: "your_ad_slot",
	maxSize: CGSize(width: 250, height: 250)
)

// Load ad
adView.loadAd { adDetail in
	print("Ad loaded:", adDetail)
} failedHandler: { error in
	print("Failed to load ad:", error)
}

// Optional: listen to height changes
adView.setOnHeightChangedListener { newHeight in
	print("Ad height updated:", newHeight)
}
```

---

### Using Custom GET Parameters

To pass custom GET parameters for ad targeting:

```swift
adView.addCustomParam(key: "interests", value: "sports")
adView.addCustomParam(key: "user_age", value: "30")
```

To remove a parameter:

```swift
adView.removeCustomParam(key: "user_age")
```

---

## License

https://optoutadvertising.com/sdk-license

---

## Contact

https://optoutadvertising.com
