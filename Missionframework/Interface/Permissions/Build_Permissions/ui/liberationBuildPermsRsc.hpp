#include "..\defines.hpp"

class LiberationBuildPermsRsc {
    idd = IDD_BUILD_PERMS_MENU;
    movingEnable = false;
    onLoad = "[_this # 0] call KPLIB_fnc_build_perms_loadMenu";
    onUnload = "[_this # 0] call KPLIB_fnc_build_perms_unloadMenu";

    controls[] = { "OuterBG1", "OuterBG_F1", "InnerBG1", "InnerBG_F1", "Header", "ButtonClose", "PermissionsControlGroup" };

    objects[] = {};

    class OuterBG1: StdBG {
        colorBackground[] = COLOR_BROWN;
        x = (0.2 * safezoneW + safezoneX) - (2 * BORDERSIZE);
        y = (0.15 * safezoneH + safezoneY) - (3 * BORDERSIZE);
        w = (0.6 * safezoneW) + (4 * BORDERSIZE);
        h = (0.64 * safezoneH);
    };
    class OuterBG_F1: OuterBG1 {
        style = ST_FRAME;
    };
    class InnerBG1: OuterBG1 {
        colorBackground[] = COLOR_GREEN;
        x = (0.2 * safezoneW + safezoneX)  - ( BORDERSIZE);
        y = 0.2 * safezoneH + safezoneY - (1.5 * BORDERSIZE);
        w = (0.6 * safezoneW) +  (2 * BORDERSIZE);
        h = 0.55 * safezoneH  + (3 * BORDERSIZE);
    };
    class InnerBG_F1: InnerBG1 {
        style = ST_FRAME;
    };
    class Header: StdHeader {
        x = 0.2 * safezoneW + safezoneX - (BORDERSIZE);
        y = 0.14 * safezoneH + safezoneY;
        w = 0.6 * safezoneW + ( 2 * BORDERSIZE);
        h = 0.05 * safezoneH - (BORDERSIZE);
        text = $STR_BUILD_PERMISSIONS_TITLE;
    };
    class ButtonClose: StdButton {
        idc = IDC_PERM_BUTTON_CLOSE;
        x = 0.785 * safezoneW + safezoneX;
        y = 0.145 * safezoneH + safezoneY;
        w = 0.015 * safezoneW;
        h = 0.02 * safezoneH;
        text = "X";
        onButtonClick = "(ctrlParent (_this # 0)) closeDisplay 1";
    };
    class PermissionsControlGroup {
        type = 15;
        idc = IDC_PERM_CONTROL_GRP;
        style = 0;
        x = (0.2 * safezoneW + safezoneX)  - ( BORDERSIZE);
        y = 0.2 * safezoneH + safezoneY;
        w = (0.6 * safezoneW) +  (BORDERSIZE);
        h = 0.55 * safezoneH ;
        colorScrollbar[] = COLOR_WHITE;
         class VScrollbar {
             color[] = COLOR_WHITE;
             width = 0.01 * safezoneW;
            autoScrollSpeed = 5;
            autoScrollDelay = 25;
            autoScrollRewind = 0;
         };
         class HScrollbar {
             color[] = COLOR_WHITE;
             height = 0.012 * safezoneH;
         };
         class ScrollBar {
            color[] = COLOR_WHITE;
            colorActive[] = COLOR_WHITE;
            colorDisabled[] = COLOR_WHITE;
            thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
            arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
            arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
            border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
         };
         class Controls {};
     };
};
