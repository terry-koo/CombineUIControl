import XCTest
import UIKit
import Combine
@testable import CombineUIControl

final class CombineUIControlTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!
    var control: UIControl!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        control = UIControl()
    }
    
    override func tearDown() {
        cancellables = nil
        control = nil
        super.tearDown()
    }
    
    func testControlEventPublisher() {
        // Given
        var eventCount = 0
        let expectedCount = 3
        let expectation = XCTestExpectation(description: "Control events received")
        
        // When
        DispatchQueue.main.async {
            self.control.publisher(for: .touchUpInside)
                .sink { _ in
                    eventCount += 1
                    if eventCount == expectedCount {
                        expectation.fulfill()
                    }
                }
                .store(in: &self.cancellables)
            
            // Then
            for _ in 0..<expectedCount {
                self.control.sendActions(for: .touchUpInside)
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(eventCount, expectedCount)
    }
    
    func testMultipleSubscriptions() {
        // Given
        var firstCount = 0
        var secondCount = 0
        let expectedCount = 2
        let expectation = XCTestExpectation(description: "Multiple subscriptions received events")
        
        // When
        DispatchQueue.main.async {
            let publisher = self.control.publisher(for: .touchUpInside)
            
            publisher
                .sink { _ in
                    firstCount += 1
                    if firstCount == expectedCount && secondCount == expectedCount {
                        expectation.fulfill()
                    }
                }
                .store(in: &self.cancellables)
            
            publisher
                .sink { _ in
                    secondCount += 1
                    if firstCount == expectedCount && secondCount == expectedCount {
                        expectation.fulfill()
                    }
                }
                .store(in: &self.cancellables)
            
            // Then
            for _ in 0..<expectedCount {
                self.control.sendActions(for: .touchUpInside)
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(firstCount, expectedCount)
        XCTAssertEqual(secondCount, expectedCount)
    }
    
    func testCancellation() {
        let expectation = XCTestExpectation(description: "Cancellation test")
        var eventCount = 0
        
        DispatchQueue.main.async {
            // When
            let cancellable = self.control.publisher(for: .touchUpInside)
                .sink { _ in
                    eventCount += 1
                }
            
            self.control.sendActions(for: .touchUpInside)
            cancellable.cancel()
            self.control.sendActions(for: .touchUpInside)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
        // Then
        XCTAssertEqual(eventCount, 1, "이벤트는 구독 취소 전에만 수신되어야 합니다")
    }
    
    func testMultipleEventTypes() {
        // Given
        var touchUpInsideCount = 0
        var valueChangedCount = 0
        let expectation = XCTestExpectation(description: "Multiple event types received")
        
        // When
        DispatchQueue.main.async {
            self.control.publisher(for: .touchUpInside)
                .sink { _ in
                    touchUpInsideCount += 1
                    if touchUpInsideCount == 2 && valueChangedCount == 2 {
                        expectation.fulfill()
                    }
                }
                .store(in: &self.cancellables)
            
            self.control.publisher(for: .valueChanged)
                .sink { _ in
                    valueChangedCount += 1
                    if touchUpInsideCount == 2 && valueChangedCount == 2 {
                        expectation.fulfill()
                    }
                }
                .store(in: &self.cancellables)
            
            // Then
            for _ in 0..<2 {
                self.control.sendActions(for: .touchUpInside)
                self.control.sendActions(for: .valueChanged)
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(touchUpInsideCount, 2)
        XCTAssertEqual(valueChangedCount, 2)
    }
    
    func testMemoryLeak() {
        let expectation = XCTestExpectation(description: "Memory leak test")
        
        DispatchQueue.main.async {
            // Given
            var control: UIControl? = UIControl()
            weak var weakControl = control
            var cancellables = Set<AnyCancellable>()
            
            // When
            control?.publisher(for: .touchUpInside)
                .sink { _ in }
                .store(in: &cancellables)
            
            // Then
            control = nil
            cancellables.removeAll()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                XCTAssertNil(weakControl, "UIControl이 해제되어야 합니다")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}