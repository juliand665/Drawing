import CoreGraphics

class ResizableRectScene: Scene {
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
		context.setFillColor(isDragging ? #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))
		context.fill(rect)
		
		// outline
		context.setStrokeColor(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1))
		context.setLineWidth(1)
		context.stroke(rect)
	}
	
	func handle(_ touch: Touch) {
		let tolerance: CGFloat = 30
		
		guard rect.contains(touch, withTolerance: tolerance) else { return }
		
		let widthSize = CGSize(width: rect.width, height: 0)
		let heightSize = CGSize(width: 0, height: rect.height)
		
		let isResizingU = CGRect(origin: rect.origin,              size: widthSize).contains(touch, withTolerance: tolerance)
		let isResizingD = CGRect(origin: rect.origin + heightSize, size: widthSize).contains(touch, withTolerance: tolerance)
		let isResizingL = CGRect(origin: rect.origin,             size: heightSize).contains(touch, withTolerance: tolerance)
		let isResizingR = CGRect(origin: rect.origin + widthSize, size: heightSize).contains(touch, withTolerance: tolerance)
		
		let isJustMoving = !isResizingU && !isResizingD && !isResizingL && !isResizingR
		
		activeTouches += 1
		container.setNeedsDisplay()
		
		let startRect = rect
		
		touch.register { (touch, event) in
			switch event {
			case .moved:
				if isJustMoving {
					self.rect.origin = startRect.origin + touch.translation
					break
				}
				
				if isResizingR {
					self.rect.size.width = startRect.size.width + touch.translation.dx
				} else if isResizingL {
					self.rect.size.width = startRect.size.width - touch.translation.dx
					self.rect.origin.x = startRect.origin.x + touch.translation.dx
				}
				
				if isResizingD {
					self.rect.size.height = startRect.size.height + touch.translation.dy
				} else if isResizingU {
					self.rect.size.height = startRect.size.height - touch.translation.dy
					self.rect.origin.y = startRect.origin.y + touch.translation.dy
				}
			case .cancelled:
				self.activeTouches -= 1
				self.rect = startRect
			case .ended:
				self.activeTouches -= 1
				self.rect = self.rect.standardized // otherwise we may have negative width/height
			}
			self.container.setNeedsDisplay()
		}
	}
}

extension CGRect {
	func contains(_ touch: Touch, withTolerance tolerance: CGFloat = 0) -> Bool {
		let offset = CGSize(x: tolerance, y: tolerance)
		let tolerating = CGRect(origin: origin - offset, size: size + 2 * offset)
		return tolerating.contains(touch.startPosition)
	}
}
