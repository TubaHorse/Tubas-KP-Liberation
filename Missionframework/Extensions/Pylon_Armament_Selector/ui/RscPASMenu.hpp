/*
	missionConfigFile >> "PIG_PAS_RscMainMenu"
*/

#include "..\defines.hpp"
#include "RscBaseClasses.hpp"

class PIG_PAS_RscMainMenu
{
	idd = IDD_PAS_MENU;
	movingEnable = true;
	onLoad = "[_this # 0] call KPLIB_fnc_loadPASMenu";
	onUnload = "[_this # 0] call KPLIB_fnc_unloadPASMenu";
	onMouseButtonDown = "['onMouseButtonDown', _this, PIG_PAS_RscMainMenu] call KPLIB_fnc_mouseButtonDown";
    onMouseButtonUp = "['onMouseButtonUp', _this, PIG_PAS_RscMainMenu] call KPLIB_fnc_mouseButtonUp";
	class ControlsBackground
	{
		class PAS_Background_1: PAS_Frame_Base
		{
			idc = -1;
			type = CT_STATIC;
			style = ST_BACKGROUND;
			x = 0.0342282 * safezoneW + safezoneX;
			y = 0.149922 * safezoneH + safezoneY;
			w = 0.170564 * safezoneW;
			h = 0.350078 * safezoneH;
			colorBackground[] = {0.1,0.1,0.1,0.8};
		};
		class PAS_Background_2: PAS_Frame_Base
		{
			idc = -1;
			type = CT_STATIC;
			style = ST_BACKGROUND;

			x = 0.762407 * safezoneW + safezoneX;
			y = 0.149922 * safezoneH + safezoneY;
			w = 0.209925 * safezoneW;
			h = 0.392087 * safezoneH;
			colorBackground[] = {0.1,0.1,0.1,0.8};
		};
		class PAS_Background_3: PAS_Frame_Base
		{
			idc = -1;
			type = CT_STATIC;
			style = ST_BACKGROUND;
			
			x = 0.0342279 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.170564 * safezoneW;
			h = 0.350078 * safezoneH;
			colorBackground[] = {0.1,0.1,0.1,0.8};
		};
		class mouseArea: PIG_PAS_controlsGroup {
            idc = IDC_MOUSEAREA;
            style = 16;
            type = CT_CONTROLS_GROUP;
            onMouseMoving = "['onMouseMoving', _this, PIG_PAS_RscMainMenu] call KPLIB_fnc_handleMouse";
            onMouseZChanged = "['onMouseZChanged', _this, PIG_PAS_RscMainMenu] call KPLIB_fnc_handleScrollWheel";
            onMouseHolding = "['onMouseHolding', _this, PIG_PAS_RscMainMenu] call KPLIB_fnc_handleMouse";
            x = -0.00513284 * safezoneW + safezoneX;
            y = -0.00411243 * safezoneH + safezoneY;
            w = 1.01683 * safezoneW;
            h = 1.00822 * safezoneH;
        };
	};
	class controls
	{
		class PAS_Pylons_Lb : PAS_Listbox_Base
		{
			idc = IDC_PYLONS_LISTBOX;

			onLBSelChanged = "[_this # 0, _this # 1] call KPLIB_fnc_handlePylonsLb";
			x = 0.0407883 * safezoneW + safezoneX;
			y = 0.163925 * safezoneH + safezoneY;
			w = 0.157444 * safezoneW;
			h = 0.322072 * safezoneH;
		};
		class PAS_Magazines_Lb: PAS_Listbox_Base
		{
			idc = IDC_MAGAZINES_LISTBOX;

			onLBSelChanged = "[_this # 0, _this # 1] call KPLIB_fnc_handleAirMagazinesLb";
			onLBDblClick = "[_this # 0, _this # 1] call KPLIB_fnc_setFavoriteMagazine";
			x = 0.0407883 * safezoneW + safezoneX;
			y = 0.626028 * safezoneH + safezoneY;
			w = 0.157444 * safezoneW;
			h = 0.322072 * safezoneH;
		};
		class PAS_Presets_Lb: PAS_Listbox_Base
		{
			idc = IDC_PRESETS_LISTBOX;

			onLBSelChanged = "[_this # 0, _this # 1] call KPLIB_fnc_handleAirPresetsLb";
			onLBDblClick = "[_this # 0, _this # 1] call KPLIB_fnc_handlePresetDoubleClick";
			x = 0.775527 * safezoneW + safezoneX;
			y = 0.163925 * safezoneH + safezoneY;
			w = 0.104963 * safezoneW;
			h = 0.266059 * safezoneH;
		};
		class PAS_Magazines_Combo: PIG_PAS_Combo_Base
		{
			idc = IDC_MAGAZINES_COMBO;

			onLBSelChanged = "[_this # 0, _this # 1] call KPLIB_fnc_handleMagazineCombo";
			x = 0.0342282 * safezoneW + safezoneX;
			y = 0.570016 * safezoneH + safezoneY;
			w = 0.170564 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class PAS_Save_Button: PAS_Button_Base
		{
			idc = IDC_SAVE_BUTTON;

			onButtonClick = "[_this # 0] call KPLIB_fnc_saveAirPreset";
			text = $STR_SAVE_BUTTON;
			toolTip = $STR_PAS_OVERWRITE_PRESET_TOOLTIP;
			x = 0.88705 * safezoneW + safezoneX;
			y = 0.163925 * safezoneH + safezoneY;
			w = 0.078722 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class PAS_Load_Button: PAS_Button_Base
		{
			idc = IDC_LOAD_BUTTON;

			onButtonClick = "[_this # 0] call KPLIB_fnc_handleLoadPresetButton";
			text = $STR_LOAD_BUTTON;
			toolTip = $STR_PAS_LOAD_PRESET_TOOLTIP;
			x = 0.88705 * safezoneW + safezoneX;
			y = 0.205934 * safezoneH + safezoneY;
			w = 0.078722 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class PAS_Delete_Button: PAS_Button_Base
		{
			idc = IDC_DELETE_BUTTON;

			onButtonClick = "[_this # 0] call KPLIB_fnc_deleteAirPreset";
			text = $STR_DELETE_BUTTON;
			toolTip = $STR_PAS_DELETE_PRESET_TOOLTIP;
			x = 0.88705 * safezoneW + safezoneX;
			y = 0.247944 * safezoneH + safezoneY;
			w = 0.078722 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class PAS_Rename_Button: PAS_Button_Base
		{
			idc = IDC_RENAME_BUTTON;

			onButtonClick = "[_this # 0] call KPLIB_fnc_renameAirPreset";
			text = $STR_RENAME_BUTTON;
			toolTip = $STR_PAS_RENAME_PRESET_TOOLTIP;
			x = 0.88705 * safezoneW + safezoneX;
			y = 0.443988 * safezoneH + safezoneY;
			w = 0.0656017 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class PAS_SaveNew_Button: PAS_Button_Base
		{
			idc = IDC_SAVENEW_BUTTON;

			onButtonClick = "[_this # 0] call KPLIB_fnc_saveNewAirPreset";
			text = $STR_SAVENEW_BUTTON;
			toolTip = $STR_PAS_SAVENEWPRESET_TOOLTIP;
			x = 0.782087 * safezoneW + safezoneX;
			y = 0.485997 * safezoneH + safezoneY;
			w = 0.0918423 * safezoneW;
			h = 0.0420094 * safezoneH;
		};
		class SpawAir_Rename_Edit: PAS_Edit_Base
		{
			idc = IDC_RENAME_EDIT;

			onEditChanged = "[_this # 0, _this # 1] call KPLIB_fnc_handlePresetEdit";
			x = 0.775527 * safezoneW + safezoneX;
			y = 0.443988 * safezoneH + safezoneY;
			w = 0.104963 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class PAS_Text_1002: PAS_Text_Base
		{
			idc = -1;
			style = ST_CENTER;

			text = "Pylons";
			x = 0.0342282 * safezoneW + safezoneX;
			y = 0.107913 * safezoneH + safezoneY;
			w = 0.170564 * safezoneW;
			h = 0.0280062 * safezoneH;
			colorBackground[] = {0.23,0.34,0.82,0.6};
		};
		class PAS_Text_1003: PAS_Text_Base
		{
			idc = -1;
			style = ST_CENTER;

			text = $STR_PAS_AMMUNITION_TITLE;
			x = 0.0342282 * safezoneW + safezoneX;
			y = 0.528006 * safezoneH + safezoneY;
			w = 0.170564 * safezoneW;
			h = 0.0280062 * safezoneH;
			colorBackground[] = {0.23,0.34,0.82,0.6};
		};
		class PAS_Text_1004: PAS_Text_Base
		{
			idc = -1;
			style = ST_CENTER;
			text = $STR_PAS_PRESETS_TITLE;
			x = 0.762407 * safezoneW + safezoneX;
			y = 0.107913 * safezoneH + safezoneY;
			w = 0.209925 * safezoneW;
			h = 0.0280062 * safezoneH;
			colorBackground[] = {0.23,0.34,0.82,0.6};
		};

	}
};