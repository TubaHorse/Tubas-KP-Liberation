#include "..\defines.hpp"

/*
	missionconfigfile >> "LiberationRepackageRsc"
*/
class LiberationRepackageRsc {
    idd = IDD_REPACKAGE_MENU;
    movingEnable = false;
    onLoad = "[_this # 0] call KPLIB_fnc_repackage_loadMenu";
    onUnload = "[_this # 0] call KPLIB_fnc_repackage_unLoadMenu";
    controlsBackground[] = { "OuterBG", "RepackageBG", "OuterBG_F", "InnerBG", "InnerBG_F" };
    controls[] = { "Header", "ButtonClose", "Infotext","TruckButton","BoxButton","CancelButton"};
    objects[] = {};

    class RepackageBG: BgPicture {
        x = (0.35 * safezoneW + safezoneX) - ( 2 * BORDERSIZE);
        y = (0.4 * safezoneH + safezoneY) - (3 * BORDERSIZE);
        w = (0.3 * safezoneW) + (4 * BORDERSIZE);
        h = (0.2 * safezoneH) + (6 * BORDERSIZE);
    };
    class OuterBG: StdBG {
        colorBackground[] = COLOR_BROWN;
        x = (0.35 * safezoneW + safezoneX) - ( 2 * BORDERSIZE);
        y = (0.4 * safezoneH + safezoneY) - (3 * BORDERSIZE);
        w = (0.3 * safezoneW) + (4 * BORDERSIZE);
        h = (0.2 * safezoneH) + (6 * BORDERSIZE);
    };
    class OuterBG_F: OuterBG {
        style = ST_FRAME;
    };
    class InnerBG: OuterBG {
        colorBackground[] = COLOR_GREEN;
        x = (0.35 * safezoneW + safezoneX)  - ( BORDERSIZE);
        y = 0.45 * safezoneH + safezoneY - (1.5 * BORDERSIZE);
        w = (0.3 * safezoneW) +  (2 * BORDERSIZE);
        h = 0.15 * safezoneH  + (3 * BORDERSIZE);
    };
    class InnerBG_F: InnerBG {
        style = ST_FRAME;
    };
    class Header: StdHeader {
        x = 0.35 * safezoneW + safezoneX - (BORDERSIZE);
        y = 0.39 * safezoneH + safezoneY;
        w = 0.3 * safezoneW + ( 2 * BORDERSIZE);
        h = 0.05 * safezoneH - (BORDERSIZE);
        text = $STR_BASE_REPACKAGE_TITLE;
    };
    class ButtonClose: StdButton {
        idc = IDC_CLOSE_BUTTON;
        x = 0.632 * safezoneW + safezoneX;
        w = 0.015 * safezoneW;
        h = 0.02 * safezoneH;
        y = 0.402 * safezoneH + safezoneY;
        text = "X";
        onButtonClick = "(ctrlParent (_this # 0)) closeDisplay 1";
    };
    class Infotext: StdText {
        idc = -1;
        style = ST_CENTER;
        x = (0.35 * safezoneW + safezoneX);
        w = (0.3 * safezoneW);
        h = (0.03 * safezoneH);
        y = (0.45 * safezoneH + safezoneY);
        colorText[] = {0.9, 0.9, 0.9, 1};
        text = $STR_BASE_REPACKAGE_CONFIRM;
        sizeEx = 0.03 * safezoneH;
    };
    class BoxButton: StdButton {
        idc = IDC_BOX_BUTTON;
        x = (0.349116 * safezoneW + safezoneX);
        y = 0.542009 * safezoneH + safezoneY;
        w = (0.0918423 * safezoneW);
        h = 0.0420094 * safezoneH;
        sizeEx = 0.022 * safezoneH;
        text = $STR_REPACKAGE_BOX;
        onButtonClick = "[] call KPLIB_fnc_repackage_doRepackage; (ctrlParent (_this # 0)) closeDisplay 1";
    };
    class TruckButton: StdButton {
        idc = IDC_TRUCK_BUTTON;
        x = 0.454079 * safezoneW + safezoneX;
        y = 0.542009 * safezoneH + safezoneY;
        w = (0.0918423 * safezoneW);
        h = 0.0420094 * safezoneH;
        sizeEx = 0.022 * safezoneH;
        text = $STR_REPACKAGE_TRUCK;
        onButtonClick = "['TRUCK'] call KPLIB_fnc_repackage_doRepackage; (ctrlParent (_this # 0)) closeDisplay 1";
    };
    class CancelButton: StdButton {
        idc = IDC_CANCEL_BUTTON;
        x = (0.559042 * safezoneW + safezoneX);
        y = 0.542009 * safezoneH + safezoneY;
        w = 0.0918423 * safezoneW;
        h = 0.0420094 * safezoneH;
        sizeEx = 0.022 * safezoneH;
        text = $STR_RECYCLING_CANCEL;
        onButtonClick = "(ctrlParent (_this # 0)) closeDisplay 1";
    };
};