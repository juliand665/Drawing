import Cocoa

class ViewController: NSViewController {
	@IBOutlet weak var renderView: RenderView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		renderView.renderer = DraggableRectRenderer(in: renderView!)
		//renderView.renderer = CircleRenderer(in: renderView!)
	}
	
	override func viewDidLayout() {
		super.viewDidLayout()
		
		renderView.sizeChanged()
	}
	
	// MARK: Mouse Handling
	
	var touch: Touch?
	
	override func mouseDown(with event: NSEvent) {
		touch = Touch(at: position(of: event))
		renderView.renderer.handle(touch!)
	}
	
	override func mouseDragged(with event: NSEvent) {
		touch!.touchMoved(to: position(of: event))
	}
	
	override func mouseUp(with event: NSEvent) {
		touch!.touchEnded()
		touch = nil
	}
	
	private func position(of event: NSEvent) -> CGPoint {
		let position = renderView.convert(event.locationInWindow, from: nil)
		return CGPoint(x: position.x, y: renderView.bounds.height - position.y)
	}
}

class RenderView: NSView, RendererContainer {
	var renderer: Renderer!
	
	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		
		let context = NSGraphicsContext.current!.cgContext
		// flip y-axis so origin is in upper left corner
		context.translateBy(x: 0, y: bounds.height)
		context.scaleBy(x: 1, y: -1)
		
		renderer.render(in: context, dirtyRect: dirtyRect)
	}
	
	func sizeChanged() {
		renderer.size = bounds.size
	}
	
	func setNeedsDisplay() {
		setNeedsDisplay(bounds)
	}
}
