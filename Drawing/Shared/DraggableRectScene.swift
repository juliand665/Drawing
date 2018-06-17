import CoreGraphics

/// renders a rectangle that can be dragged around
class DraggableRectScene: Scene {
	unowned var container: SceneContainer
	var size: CGSize!
	
	var rect = CGRect(x: 128, y: 64, width: 128, height: 256)
	
	var activeTouches = 0
	var isDragging: Bool {
		return activeTouches > 0
	}
	
	init(in container: SceneContainer) {
		self.container = container
	}
	
	func render(in context: CGContext, dirtyRect: CGRect) {
		// shadow
		context.setFillColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25))
		let shadowOffset: CGFloat = isDragging ? 4 : 8
		context.fill(rect.offsetBy(dx: shadowOffset, dy: shadowOffset))
		
		// rect
		context.setFillColor(isDragging ? #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
		context.fill(rect)
		
		// outline
		context.setStrokeColor(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
		context.setLineWidth(1)
		context.stroke(rect)
	}
	
	func handle(_ touch: Touch) {
		// only handle touches that actually touch the rectangle
		guard rect.contains(touch.startPosition) else { return }
		
		activeTouches += 1
		container.setNeedsDisplay()
		
		let startPosition = rect.origin
		
		touch.register { (touch, event) in
			switch event {
			case .moved:
				self.rect.origin = startPosition + touch.translation
			case .cancelled:
				self.rect.origin = startPosition
				fallthrough
			case .ended:
				self.activeTouches -= 1
			}
			self.container.setNeedsDisplay()
		}
	}
}
