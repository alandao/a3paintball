
/*
class PAINTBALL_HUD
{
	idd = -1;
	movingenable = false;
	
	class PAINTBALL_WESTALIVE: RscText
	{
		idc = 1000;
		text = "West Alive: 2"; //--- ToDo: Localize;
		x = 0.329375 * safezoneW + safezoneX;
		y = 0.024 * safezoneH + safezoneY;
		w = 0.0984375 * safezoneW;
		h = 0.028 * safezoneH;
		sizeEx = 1 * GUI_GRID_H;
	};
	class PAINTBALL_HINT: RscText
	{
		idc = 1001;
		text = "The East have the flag."; //--- ToDo: Localize;
		x = 0.355625 * safezoneW + safezoneX;
		y = 0.094 * safezoneH + safezoneY;
		w = 0.282188 * safezoneW;
		h = 0.056 * safezoneH;
		sizeEx = 2 * GUI_GRID_H;
	};
	class PAINTBALL_SCORE: RscText
	{
		idc = 1002;
		text = "3  16"; //--- ToDo: Localize;
		x = 0.460625 * safezoneW + safezoneX;
		y = 0.01 * safezoneH + safezoneY;
		w = 0.07875 * safezoneW;
		h = 0.042 * safezoneH;
		sizeEx = 2 * GUI_GRID_H;
	};
	class PAINTBALL_EASTALIVE: RscText
	{
		idc = 1003;
		text = "East alive: 1"; //--- ToDo: Localize;
		x = 0.565625 * safezoneW + safezoneX;
		y = 0.024 * safezoneH + safezoneY;
		w = 0.091875 * safezoneW;
		h = 0.028 * safezoneH;
	};

}

