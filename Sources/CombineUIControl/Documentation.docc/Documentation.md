# ``CombineUIControl``

UIKit의 UIControl 이벤트를 Combine Publisher로 변환하는 라이브러리입니다.

## 개요

CombineUIControl은 UIKit의 UIControl 컴포넌트에서 발생하는 이벤트를 Combine Publisher로 쉽게 변환할 수 있게 해주는 라이브러리입니다. 이를 통해 UIControl의 이벤트를 반응형 프로그래밍 방식으로 처리할 수 있습니다.

## 주요 기능

### UIControl Extension

```swift
extension UIControl {
    public func publisher(for events: UIControl.Event) -> AnyPublisher<Void, Never>
}
```

이 확장을 통해 모든 UIControl 인스턴스에서 특정 이벤트에 대한 Publisher를 생성할 수 있습니다.

## 사용 예제

### 기본 사용법

```swift
let button = UIButton()
button.publisher(for: .touchUpInside)
    .sink { _ in
        print("Button tapped!")
    }
    .store(in: &cancellables)
```

### 여러 이벤트 결합

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

## 주제

### 기본

- ``UIControl/publisher(for:)``
- ``Publishers/ControlEvent``

## 참고

- [GitHub 저장소](https://github.com/terry-koo/CombineUIControl)
- [Combine Framework](https://developer.apple.com/documentation/combine)
- [UIControl](https://developer.apple.com/documentation/uikit/uicontrol)