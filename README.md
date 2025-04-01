# CombineUIControl

[![Swift](https://github.com/terry-koo/CombineUIControl/actions/workflows/swift.yml/badge.svg)](https://github.com/terry-koo/CombineUIControl/actions/workflows/swift.yml)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![Platform](https://img.shields.io/badge/platforms-iOS%2013.0+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

CombineUIControl은 UIKit의 UIControl 이벤트를 Combine Publisher로 쉽게 변환할 수 있게 해주는 Swift 라이브러리입니다.

## 특징

- ✨ 간단하고 직관적인 API
- 🔄 Combine과 완벽한 통합
- 📱 iOS 13.0+ 지원
- 🧪 철저한 테스트 커버리지
- 📖 완벽한 DocC 문서화

## 요구사항

- iOS 13.0+
- Swift 5.5+
- Xcode 13.0+

## 설치 방법

### Swift Package Manager

1. Xcode에서 File > Add Packages... 메뉴를 선택합니다.
2. 검색창에 `https://github.com/terry-koo/CombineUIControl.git`를 입력합니다.
3. 버전을 선택하고 Add Package 버튼을 클릭합니다.

또는 Package.swift 파일에 다음과 같이 의존성을 추가합니다:

```swift
dependencies: [
    .package(url: "https://github.com/terry-koo/CombineUIControl.git", from: "1.0.0")
]
```

## 사용 방법

```swift
import CombineUIControl
import Combine

class ViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton()
        button.publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.handleButtonTap()
            }
            .store(in: &cancellables)
    }
    
    private func handleButtonTap() {
        print("Button tapped!")
    }
}
```

### 고급 사용 예제

여러 이벤트 결합:
```swift
let textField = UITextField()
Publishers.Merge(
    textField.publisher(for: .editingChanged),
    textField.publisher(for: .editingDidEnd)
)
.sink { _ in
    print("Text field changed or editing ended")
}
.store(in: &cancellables)
```

이벤트 필터링:
```swift
button.publisher(for: .touchUpInside)
    .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
    .sink { _ in
        print("Button tapped (debounced)!")
    }
    .store(in: &cancellables)
```

## 문서화

자세한 문서는 Xcode의 DocC 문서를 참조하세요.

## 기여하기

프로젝트에 기여하고 싶으시다면 [CONTRIBUTING.md](CONTRIBUTING.md)를 참조해 주세요.

## 라이센스

이 프로젝트는 MIT 라이센스 하에 있습니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.