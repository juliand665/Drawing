import CoreGraphics

protocol Renderer: AnyObject {
	/// the size of the drawing area
	var size: CGSize! { get set }
	
	/// this should be unowned to avoid reference cycles
	var container: RendererContainer { get set }
	
	/// renders the contents in a graphics context, optionally using `dirtyRect` to optimize performance
	func render(in context: CGContext, dirtyRect: CGRect)
	
	/// registers a handler for the touch; called when the touch begins
	func handle(_ touch: Touch)
}

protocol RendererContainer: AnyObject {
	func setNeedsDisplay()
}

// default implementations
extension Renderer {
	func handle(_ touch: Touch) {}
}
