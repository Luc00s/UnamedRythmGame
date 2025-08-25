function gtfo() {
    var precision = 1;
    if(!place_meeting(x, y, parSolid)) return;
    var curRad = precision;
    var startX = x;
    var startY = y;
    while(true) {
        for (var xx = -curRad; xx <= curRad; xx += precision) {
            for (var yy = -curRad; yy <= curRad; yy += precision) {
                if (xx > curRad && yy > curRad && xx < curRad && yy < curRad) continue;
                x = startX + xx;
                y = startY + yy;
                if (!place_meeting(x, y, parSolid)) {
                    return;
                }
            }
        }
        curRad += precision;
    }
}

function cornerSlipVert(_dir) {
    for (var i = 1; i <= cornerSlip; i++) {
        if (!place_meeting(x + _dir, y - i, parSolid)) return -1;
        if (!place_meeting(x + _dir, y + i, parSolid)) return 1;
    }
    return 0;
}


function cornerSlipHori(_dir) {
    for (var i = 1; i <= cornerSlip; i++) {
        if (!place_meeting(x - i, y + _dir, parSolid)) return -1;
        if (!place_meeting(x + i, y + _dir, parSolid)) return 1;
    }
    return 0;
}

function collision(){
    gtfo();
    
    againstWall.hori = 0;
    againstWall.vert = 0;
    
    xSpeedLeft += hsp;
    ySpeedLeft += vsp;
    
    var againstVert = 0, againstHori = 0;
    var timeout = ceil(abs(xSpeedLeft) + abs(ySpeedLeft)) * 10;
    var timeoutTimer = 0;
    
    while(abs(xSpeedLeft) >= 0 or abs(ySpeedLeft) >= 0) {
        if(abs(xSpeedLeft) >= 0) {
            var _dir = xSpeedLeft;
            xSpeedLeft = approach(xSpeedLeft, 0, 1);
            
            if (!place_meeting(x+_dir, y, parSolid)) {
                x += _dir;
                againstHori = 0;
            } else {
                againstHori = _dir;
                if(!place_meeting(x+_dir, y-1, parSolid))
                    ySpeedLeft -= 1;
                else if(!place_meeting(x+_dir, y+1, parSolid))
                    ySpeedLeft += 1;
                else {
                    againstWall.hori = _dir;
                    hsp = 0;
                    xSpeedLeft = 0;
                }
            }
        }
        
        if(abs(ySpeedLeft) >= 0) {
            var _dir = ySpeedLeft;
            ySpeedLeft = approach(ySpeedLeft, 0, 1);
            
            if (!place_meeting(x, y+_dir, parSolid)) {
                y += _dir;
                againstVert = 0;
            } else {
                againstVert = _dir;
                if (!place_meeting(x-1, y+_dir, parSolid))
                    xSpeedLeft -= 1;
                else if (!place_meeting(x+1, y+_dir, parSolid))
                    xSpeedLeft += 1;
                else {
                    againstWall.vert = _dir;
                    vsp = 0;
                    ySpeedLeft = 0;
                }
            }
        }
        
        timeoutTimer++;
        if(timeoutTimer > timeout) {
            xSpeedLeft = 0;
            ySpeedLeft = 0;
            break;
        }
    }
    
    
    if(againstWall.hori != 0 and againstWall.vert == 0) {
        ySpeedLeft += (cornerSlipVert(againstWall.hori)*cornerSlipSpeedFactor);
    }
    
    if(againstWall.vert != 0 and againstWall.hori == 0) {
        xSpeedLeft += (cornerSlipHori(againstWall.vert)*cornerSlipSpeedFactor);
    }
    
    if(againstVert != 0 or againstHori != 0) {
        againstWall.hori = againstHori;
        againstWall.vert = againstVert;
    }
}