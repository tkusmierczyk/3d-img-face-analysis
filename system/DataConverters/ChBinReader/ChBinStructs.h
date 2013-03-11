               
#ifndef CHBINSTRUCTS_H
#define CHBINSTRUCTS_H

#include <stdio.h>

 typedef enum 
 {
	 SORT_NONE,
	 SORT_X,
	 SORT_Y,
	 SORT_Z
 } SORT_STATE_v10;

 typedef struct
 {
         float x,y,z;
 } sPointXYZ_v10;

 typedef struct
 {
         unsigned char r,g,b;
 } sPointRGB_v10;

 typedef struct
 {
         float x,y,z;
         unsigned char r,g,b;
         unsigned char state;
 } sCloudPoint_v10;

 typedef struct
 {
         unsigned int uiFileFormatID_Major; 
         unsigned int uiFileFormatID_Minor;  
         unsigned int uiCloudCount;
         unsigned int uiAllPointsCount;
         float fX_Max,fX_Min;
         float fY_Max,fY_Min;
         float fZ_Max,fZ_Min;
         float m[16];
         sPointXYZ_v10 sRotationCenter;
         int iCloudWithSelectedPoint;
 } sCloudsBinaryHeader_v10;

 typedef struct
 {
         float fX_Max,fX_Min;
         float fY_Max,fY_Min;
         float fZ_Max,fZ_Min;
         SORT_STATE_v10 iSorted;
         unsigned int uiCount;
         unsigned int uiSelectedPoint;
         char pcCloudName[256];
         sPointRGB_v10 colNormal;
         float fNormalSize;
         int iDrawCloudRGB;
         sPointRGB_v10 colSelected;
         float fSelectedSize;
         int iDarkMode;
         int iHidden;
 } sSingleCloudBinaryHeader_v10;

 void fprintfChBinHeader(FILE* f, sCloudsBinaryHeader_v10* header);
 void fprintfChBinCloudHeader(FILE* f, sSingleCloudBinaryHeader_v10* h);
 void fprintfChBinPoint(FILE* f, sCloudPoint_v10* p);

#endif