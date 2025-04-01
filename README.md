# CombineUIControl

CombineUIControl은 UIKit의 UIControl 이벤트를 Combine Publisher로 쉽게 변환할 수 있게 해주는 Swift 라이브러리입니다.

## 요구사항

- iOS 13.0+
- Swift 5.5+
- Xcode 13.0+

## 설치 방법

### Swift Package Manager

1. Xcode에서 File > Add Packages... 메뉴를 선택합니다.
2. 검색창에 `https://github.com/terry-koo/CombineUIControl.git`를 입력합니다.
3. 버전을 선택하고 Add Package 버튼을 클릭합니다.

## 사용 방법

```swift
import CombineUIControl

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

## 라이센스

MIT License