import UIKit
import Combine

extension UIControl {
    public func publisher(for events: UIControl.Event) -> AnyPublisher<Void, Never> {
        Publishers.ControlEvent(control: self, events: events)
            .eraseToAnyPublisher()
    }
}

extension Publishers {
    public struct ControlEvent: Publisher {
        public typealias Output = Void
        public typealias Failure = Never
        
        let control: UIControl
        let events: UIControl.Event
        
        public init(control: UIControl, events: UIControl.Event) {
            self.control = control
            self.events = events
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Void == S.Input {
            let subscription = Subscription(subscriber: subscriber, control: control, events: events)
            subscriber.receive(subscription: subscription)
        }
    }
}

private extension Publishers.ControlEvent {
    class Subscription<S: Subscriber>: Combine.Subscription where S.Input == Void, S.Failure == Never {
        private var subscriber: S?
        private let control: UIControl
        private let events: UIControl.Event
        
        init(subscriber: S, control: UIControl, events: UIControl.Event) {
            self.subscriber = subscriber
            self.control = control
            self.events = events
            
            control.addTarget(self, action: #selector(handleEvent), for: events)
        }
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {
            control.removeTarget(self, action: #selector(handleEvent), for: events)
            subscriber = nil
        }
        
        @objc private func handleEvent() {
            _ = subscriber?.receive(())
        }
    }
}