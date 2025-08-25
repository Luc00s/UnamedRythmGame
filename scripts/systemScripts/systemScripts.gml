function approach(argument0, argument1, argument2) {
	if (argument0 < argument1) return min(argument0 + argument2, argument1);
	else return max(argument0 - argument2, argument1);
}

function smooth_approach(argument0, argument1, argument2) {
	var diff = (argument1 - argument0);
	
	if (abs(diff) < 0.0005) return argument1;
	else return (argument0 + ((sign(diff) * abs(diff)) * argument2));
}

function wave(_from, _to, _duration, _offset, _time) {
	//wave(from, to, duration, offset, time)
	var a4 = (_to-_from)*0.5;
	return _from + a4 + sin((((_time) + _duration * _offset) / _duration) * (pi*2)) * a4;
}

function wrap(_val, _min, _max) {
	/// wrap(val,min,max);
	//
	//  Returns the value warped in the given range. 
	//  Give the value you want to wrap, 
	//  and the minimal and maximum values you want to keep your value in
	//  
	//      val     value of the varible your setting   , real
	//      min     the lowest value                    , real
	//      max     the greatest value                  , real
	//
	//  Use your own direction value and keep between 0 and 359
	//  ex: dir = wrap(dir, 0, 359);
	//
	/// GMLscripts.com/license
    var _range = _max - _min;
    
    // Keep adding or subtracting range to the value until its wraped.
    if(_min != _max) {
        while (_val < _min) _val += _range;
        while (_val > _max) _val -= _range; 
    } else {
        _val = _min;
    }
    
    // Return the value.
    return(_val);
}