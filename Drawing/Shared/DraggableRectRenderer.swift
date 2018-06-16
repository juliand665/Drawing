import CoreGraphics

/// renders a rectangle that can be dragged around
class DraggableRectRenderer: Renderer {
	unowned var container: RendererContainer
	var size: CGSize!
	
	var rectPosition = CGPoint(x: 128, y: 64)
	
	var activeTouches = 0
	var isDragging: Bool {
		return activeTouches > 0
	}
	
	init(in container: RendererContainer) {
		self.container = container
	}
	
	func render(in context: CGContext, dirtyRect: CGRect) {
		let rect = CGRect(origin: rectPosition, size: CGSize(width: 128, height: 256))
		
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
		activeTouches += 1
		container.setNeedsDisplay()
		
		let startPosition = rectPosition
		touch.register { (touch, event) in
			switch event {
			case .moved:
				self.rectPosition = startPosition + touch.translation
			case .cancelled:
				self.rectPosition = startPosition
				fallthrough
			case .ended:
				self.activeTouches -= 1
			}
			self.container.setNeedsDisplay()
		}
	}
}
