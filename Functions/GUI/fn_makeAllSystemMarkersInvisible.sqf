{
    if (getMarkerType _x  == "mil_start" || getMarkerType _x  == "respawn_inf" || getMarkerType _x == "mil_destroy") 
    then { _x setMarkerAlpha 0;}    
} forEach allMapMarkers