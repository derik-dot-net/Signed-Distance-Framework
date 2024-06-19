function _sdf_shape(_array) constructor {
	
	// Data for this SDF
	data = _array;
	updated = true;
	
	// if the user tries to use a function not related to the shape
	// throw an error, like setting the radius of a cube or plane for example
	
	// Color
	static rgb = function (_r, _g, _b, _linear = false) {
		
		// Delete Old Color Entry
		for (var i = 0; i < array_length(data); i++) {
			if data[i] = _sdf_color_0 {
				array_delete(data, i, 4);
			}
		}
		
		// Add New Data
		if _linear {
			array_push(data, _sdf_color_0, _r, _g, _b);
		} else {
			array_push(data, _sdf_color_0, _r / 255, _g / 255, _b / 255);
		}
		
		//Set Updated
		updated = true;
	
	}
	
	// Intersection Type
	static intersection = function(_operation) {
		
		// Delete Old Intersection Entry
		for (var i = 0; i < array_length(data); i++) {
			if data[i] = _sdf_intersection {
				array_delete(data, i, 2);
			}
		}
		
		// Add New Data
		array_push(data, _sdf_intersection, _operation);
		
		//Set Updated
		updated = true;
		
	}
	
}