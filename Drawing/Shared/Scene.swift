import CoreGraphics

func defaultScene(in container: SceneContainer) -> Scene {
	// adjust this to change which scene you're rendering without having to edit the platform-specific code
	return CircleScene(in: container)
}

protocol Scene: AnyObject {
	/// the size of the drawing area
	var size: CGSize! { get set }
	
	/// this should be unowned to avoid reference cycles
	var container: SceneContainer { get set }
	
	/// renders the contents in a graphics context, optionally using `dirtyRect` to optimize performance
	func render(in context: CGContext, dirtyRect: CGRect)
	
	/// registers a handler for the touch; called when the touch begins
	func handle(_ touch: Touch)
}

protocol SceneContainer: AnyObject {
	func setNeedsDisplay()
}

// default implementations
extension Scene {
	func handle(_ touch: Touch) {}
}
