import Cocoa

typealias Color = NSColor

extension NSColor: _Color {
	var alpha: CGFloat {
		return alphaComponent
	}
	
	var red: CGFloat {
		return redComponent
	}
	
	var green: CGFloat {
		return greenComponent
	}
	
	var blue: CGFloat {
		return blueComponent
	}
	
	var hue: CGFloat {
		return hueComponent
	}
	
	var saturation: CGFloat {
		return saturationComponent
	}
	
	var brightness: CGFloat {
		return brightnessComponent
	}
}
