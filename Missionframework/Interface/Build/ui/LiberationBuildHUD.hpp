#include "..\defines.hpp"

class KPLIB_BUILD_RscBuildControls
{
    idd = BUILD_HUD_IDD;
    fadein = 0;
    fadeout = 0;
    duration = 1e11;
    onLoad = "localNameSpace setVariable ['KPLIB_BUILD_hudDisplay', _this select 0]";
    onUnLoad = "localNameSpace setVariable ['KPLIB_BUILD_hudDisplay', nil];";
    class Controls 
	{
		class Text_Build : StdStructuredText
		{
			idc = BUILD_TEXT;
			text = "Build";
			x = 0.381917 * safezoneW + safezoneX;
			y = 0.864081 * safezoneH + safezoneY;
			w = 0.118083 * safezoneW;
			h = 0.0420094 * safezoneH;
		};
		class Text_Repeat_Build : StdStructuredText
		{
			idc = REPEAT_BUILD_TEXT;
			text = "Repeat Build";
			x = 0.381917 * safezoneW + safezoneX;
			y = 0.924081 * safezoneH + safezoneY;
			w = 0.158083 * safezoneW;
			h = 0.0420094 * safezoneH;
		};
		class Text_Cancel : StdStructuredText
		{
			idc = CANCEL_BUILD_TEXT;
			text = "Cancel";
			x = 0.545921 * safezoneW + safezoneX;
			y = 0.864081 * safezoneH + safezoneY;
			w = 0.118083 * safezoneW;
			h = 0.0420094 * safezoneH;
		};
		class Mode_Actions_Text: StdStructuredText
		{
			idc = MODE_ACTIONS_TEXT;
			text = "MODE ACTIONS";
			style = ST_CENTER;
			x = 0.814888 * safezoneW + safezoneX;
			y = 0.640031 * safezoneH + safezoneY;
			w = 0.124643 * safezoneW;
			h = 0.0420094 * safezoneH;
		};
		class Rotate_Mode_Text: StdStructuredText
		{
			idc = ROTATE_MODE_TEXT;
			text = "Rotation";
			x = 0.841129 * safezoneW + safezoneX;
			y = 0.696044 * safezoneH + safezoneY;
			w = 0.124643 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class Height_Mode_Text : StdStructuredText
		{
			idc = HEIGHT_MODE_TEXT;
			text = "Height";
			x = 0.841129 * safezoneW + safezoneX;
			y = 0.738053 * safezoneH + safezoneY;
			w = 0.124643 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class ModeY_Text : StdStructuredText
		{
			idc = MODEY_MODE_TEXT;
			text = "Foward/Backward";
			x = 0.841129 * safezoneW + safezoneX;
			y = 0.780062 * safezoneH + safezoneY;
			w = 0.124643 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class Snap_Mode_Text : StdStructuredText
		{
			idc = SNAP_MODE_TEXT;
			text = "Snap To Ground";
			x = 0.841129 * safezoneW + safezoneX;
			y = 0.822072 * safezoneH + safezoneY;
			w = 0.124643 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class Vector_Mode_Text : StdStructuredText
		{
			idc = VERTICAL_MODE_TEXT;
			text = "Vertical";
			x = 0.841129 * safezoneW + safezoneX;
			y = 0.864081 * safezoneH + safezoneY;
			w = 0.124643 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class Boost_Mode_Text : StdStructuredText
		{
			idc = BOOST_MODE_TEXT;
			text = "Boost";
			x = 0.841129 * safezoneW + safezoneX;
			y = 0.90609 * safezoneH + safezoneY;
			w = 0.124643 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class Camera_Mode_Text : StdStructuredText
		{
			idc = CAMERA_MODE_TEXT;
			text = "Camera Assist";
			x = 0.841129 * safezoneW + safezoneX;
			y = 0.9481 * safezoneH + safezoneY;
			w = 0.124643 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class Default_Mode_Text: StdText
		{
			idc = -1;
			text = "DEFAULT";
			x = 0.782087 * safezoneW + safezoneX;
			y = 0.696044 * safezoneH + safezoneY;
			w = 0.0524813 * safezoneW;
			h = 0.0280062 * safezoneH;
			sizeEx = 0.025 * safezoneH;
		};
		class Ctrl_Key_Text : StdText
		{
			idc = -1;
			text = "CTRL";
			x = 0.782087 * safezoneW + safezoneX;
			y = 0.780062 * safezoneH + safezoneY;
			w = 0.0524813 * safezoneW;
			h = 0.0280062 * safezoneH;
			sizeEx = 0.025 * safezoneH;
		};
		class Alt_Key_Text : StdText
		{
			idc = -1;
			text = "ALT";
			x = 0.782087 * safezoneW + safezoneX;
			y = 0.738053 * safezoneH + safezoneY;
			w = 0.0524813 * safezoneW;
			h = 0.0280062 * safezoneH;
			sizeEx = 0.025 * safezoneH;
		};
		class Capslock_Key_Text : StdText
		{
			idc = -1;
			text = "CAPS";
			x = 0.782087 * safezoneW + safezoneX;
			y = 0.822072 * safezoneH + safezoneY;
			w = 0.0524813 * safezoneW;
			h = 0.0280062 * safezoneH;
			sizeEx = 0.025 * safezoneH;
		};
		class Space_Key_Text : StdText
		{
			idc = -1;
			text = "SPACE";
			x = 0.782087 * safezoneW + safezoneX;
			y = 0.864081 * safezoneH + safezoneY;
			w = 0.0524813 * safezoneW;
			h = 0.0280062 * safezoneH;
			sizeEx = 0.025 * safezoneH;
		};
		class Shift_Key_Text : StdText
		{
			idc = -1;
			text = "SHIFT";
			x = 0.782087 * safezoneW + safezoneX;
			y = 0.90609 * safezoneH + safezoneY;
			w = 0.0524813 * safezoneW;
			h = 0.0280062 * safezoneH;
			sizeEx = 0.025 * safezoneH;
		};
		class Tab_Key_Text : StdText
		{
			idc = -1;
			text = "TAB";
			x = 0.782087 * safezoneW + safezoneX;
			y = 0.9481 * safezoneH + safezoneY;
			w = 0.0524813 * safezoneW;
			h = 0.0280062 * safezoneH;
			sizeEx = 0.025 * safezoneH;
		};
	};
};