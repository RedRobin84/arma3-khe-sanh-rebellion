_max = _this;

_randomNumber = ceil(random _max);
    if (_randomNumber < 10) then {
        //RETURN
        "0" + str(_randomNumber)
    };
    //ELSE RETURN
    str(_randomNumber)