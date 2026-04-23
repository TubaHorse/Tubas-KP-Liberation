#include "..\defines.hpp"

/*
	missionconfigfile >> "LiberationBaseNameRsc"
*/
class LiberationBaseNameRsc {
    idd = IDD_BASENAME_MENU;
    movingEnable = false;
    onLoad = "[_this # 0] call KPLIB_fnc_baseName_loadMenu";
    onUnload = "[_this # 0] call KPLIB_fnc_baseName_unLoadMenu";
    controlsBackground[] = {};
    class controls {
		class BaseNameOutBg: StdBG
		{
			idc = -1;
			x = 0.401597 * safezoneW + safezoneX;
			y = 0.387975 * safezoneH + safezoneY;
			w = 0.196805 * safezoneW;
			h = 0.210047 * safezoneH;
			colorBackground[] = COLOR_BROWN;
		};
		class BaseNameOutPic: BgPicture
		{
			idc = -1;
			x = 0.401597 * safezoneW + safezoneX;
			y = 0.387975 * safezoneH + safezoneY;
			w = 0.196805 * safezoneW;
			h = 0.210047 * safezoneH;
		};
		class baseNameBg: StdBG
		{
			idc = -1;
			x = 0.408158 * safezoneW + safezoneX;
			y = 0.457991 * safezoneH + safezoneY;
			w = 0.183685 * safezoneW;
			h = 0.126028 * safezoneH;
			colorBackground[] = COLOR_GREEN;
		};
		class BaseNameFrame: baseNameBg
		{
			style = ST_FRAME;
		};
		class BaseNameTitle: StdHeader
		{
			idc = -1;
			text = $STR_BASE_NAME_HEADER;
			x = 0.408158 * safezoneW + safezoneX;
			y = 0.401978 * safezoneH + safezoneY;
			w = 0.183685 * safezoneW;
			h = 0.0420094 * safezoneH;
			
		};
		class BaseNameEdit: StdEdit
		{
			idc = IDC_EDIT;
			x = 0.447519 * safezoneW + safezoneX;
			y = 0.471994 * safezoneH + safezoneY;
			w = 0.104963 * safezoneW;
			h = 0.0420094 * safezoneH;
			style = ST_LEFT;
			sizeEx = 0.025 * safezoneH;
			onEditChanged = "[_this # 0, _this # 1] call KPLIB_fnc_baseName_checkEdit";
			maxChars = 14;
		};
		class BaseNameConfirm: StdButton
		{
			idc = IDC_CONFIRM_BUTTON;
			text = $STR_CONFIRM;
			x = 0.427838 * safezoneW + safezoneX;
			y = 0.528006 * safezoneH + safezoneY;
			w = 0.0590415 * safezoneW;
			h = 0.0280062 * safezoneH;
			onButtonClick = "[_this # 0] call KPLIB_fnc_baseName_setNewName";
			sizeEx = 0.025 * safezoneH;
		};
		class BaseNameDefault: StdButton
		{
			idc = IDC_DEFAULT_BUTTON;
			text = $STR_DEFAULT;
			x = 0.51312 * safezoneW + safezoneX;
			y = 0.528006 * safezoneH + safezoneY;
			w = 0.0590415 * safezoneW;
			h = 0.0280062 * safezoneH;
			tooltip = $STR_BASE_NAME_DEFAULT_TOOLTIP;
			onButtonClick = "[_this # 0] call KPLIB_fnc_baseName_setDefaultName";
			sizeEx = 0.025 * safezoneH;
		};
		class BaseNameClose: StdButton
		{
			idc = IDC_CLOSE_BUTTON;
			text = "X";
			x = 0.572162 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.0131203 * safezoneW;
			h = 0.0140031 * safezoneH;
			onButtonClick = "(ctrlParent (_this # 0)) closeDisplay 1";
		};
    };
};