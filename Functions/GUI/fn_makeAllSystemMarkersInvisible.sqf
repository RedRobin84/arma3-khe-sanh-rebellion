{
    if (getMarkerType _x  == "mil_start" || getMarkerType _x  == "respawn_inf" || getMarkerType _x == "mil_destroy" || markerText _x == "ai_spawn_range") 
    then { _x setMarkerAlpha 0;}    
} forEach allMapMarkers
//VOID
