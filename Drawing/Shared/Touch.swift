import CoreGraphics

class Touch {
	typealias Handler = (Touch, Event) -> Void
	
	/// the position this touch had when it began
	var startPosition: CGPoint
	
	/// the position this touch had last time an event was handled
	var previousPosition: CGPoint?
	
	/// the current position
	var position: CGPoint {
		willSet {
			previousPosition = position
		}
	}
	
	/// the translation relative to the starting position
	var translation: CGVector {
		return position.asVector - startPosition
	}
	
	private var handlers: [Handler] = []
	
	init(at position: CGPoint) {
		self.position = position
		startPosition = position
	}
	
	/// registers a handler to handle any further events for this touch
	func register(_ handler: @escaping Handler) {
		assert(previousPosition == nil)
		handlers.append(handler)
	}
	
	func touchMoved(to position: CGPoint) {
		self.position = position
		handle(.moved)
	}
	
	func touchEnded() {
		handle(.ended)
	}
	
	func touchCancelled() {
		handle(.cancelled)
	}
	
	private func handle(_ event: Event) {
		handlers.forEach { $0(self, event) }
	}
	
	enum Event {
		case moved
		case ended
		case cancelled
	}
}
