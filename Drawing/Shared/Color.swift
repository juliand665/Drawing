import CoreGraphics

/**
Provides a unified interface for accessing colors across platforms. As long as you stick to only using these methods (and color literals), your code should compile on any platform.

There is a platform-dependent `typealias Color` somewhere that gives you an appropriate type which conforms to this protocol as a sanity check.
*/
protocol _Color {
	var alpha: CGFloat { get }
	
	var red: CGFloat { get }
	var green: CGFloat { get }
	var blue: CGFloat { get }
	
	var hue: CGFloat { get }
	var saturation: CGFloat { get }
	var brightness: CGFloat { get }
	
	var cgColor: CGColor { get }
	
	init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
	init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
}
