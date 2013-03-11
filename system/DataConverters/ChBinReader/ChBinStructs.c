
#ifndef CHBINSTRUCTS_C
#define CHBINSTRUCTS_C

#include "ChBinStructs.h"

void fprintfChBinPoint(FILE* f, sCloudPoint_v10* p)
{
	fprintf(f, "%f %f %f  %i %i %i  %i\n", p->x,p->y,p->z,p->r,p->g,p->b,p->state);
}

void fprintfChBinCloudHeader(FILE* f, sSingleCloudBinaryHeader_v10* h)
{

	fprintf(f, "pcCloudName = %s\n", h->pcCloudName);
	fprintf(f, "iSorted = %i\n", h->iSorted);
	fprintf(f, "uiCount = %i\n", h->uiCount);
	fprintf(f, "uiSelectedPoint = %i\n", h->uiSelectedPoint);
	fprintf(f, "fNormalSize = %f\n", h->fNormalSize);
	fprintf(f, "iDrawCloudRGB = %i\n", h->iDrawCloudRGB);
	fprintf(f, "iDarkMode = %i\n", h->iDarkMode);
	fprintf(f, "iHidden = %i\n", h->iHidden);
	fprintf(f, "fSelectedSize = %f\n", h->fSelectedSize);
	fprintf(f, "colNormal.r = %i\n", h->colNormal.r);
	fprintf(f, "colNormal.g = %i\n", h->colNormal.g);
	fprintf(f, "colNormal.b = %i\n", h->colNormal.b);
	fprintf(f, "colSelected.r = %i\n", h->colSelected.r);
	fprintf(f, "colSelected.g = %i\n", h->colSelected.g);
	fprintf(f, "colSelected.b = %i\n", h->colSelected.b);
	fprintf(f, "fX_Max = %f\n", h->fX_Max);
	fprintf(f, "fX_Min = %f\n", h->fX_Min);
	fprintf(f, "fY_Max = %f\n", h->fY_Max);
	fprintf(f, "fY_Min = %f\n", h->fY_Min);
	fprintf(f, "fZ_Max = %f\n", h->fZ_Max);
	fprintf(f, "fZ_Min = %f\n", h->fZ_Min);                              
}

void fprintfChBinHeader(FILE* f, sCloudsBinaryHeader_v10* h)
{
	fprintf(f, "uiFileFormatID_Major = %i\n", h->uiFileFormatID_Major);
	fprintf(f, "uiFileFormatID_Minor = %i\n", h->uiFileFormatID_Minor);
	fprintf(f, "uiCloudCount = %i\n", h->uiCloudCount);
	fprintf(f, "uiAllPointsCount = %i\n", h->uiAllPointsCount);
	fprintf(f, "fX_Max = %f\n", h->fX_Max);
	fprintf(f, "fX_Min = %f\n", h->fX_Min);
	fprintf(f, "fY_Max = %f\n", h->fY_Max);
	fprintf(f, "fY_Min = %f\n", h->fY_Min);
	fprintf(f, "fZ_Max = %f\n", h->fZ_Max);
	fprintf(f, "fZ_Min = %f\n", h->fZ_Min);
	fprintf(f, "m = %f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n", 
		h->m[0],h->m[1],h->m[2],h->m[3],h->m[4],
		h->m[5],h->m[6],h->m[7],h->m[8],
		h->m[9],h->m[10],h->m[11],h->m[12],
		h->m[13],h->m[14],h->m[15]);
	fprintf(f, "sRotationCenter.x = %f\n", h->sRotationCenter.x);
	fprintf(f, "sRotationCenter.y = %f\n", h->sRotationCenter.y);
	fprintf(f, "sRotationCenter.z = %f\n", h->sRotationCenter.z);
	fprintf(f, "iCloudWithSelectedPoint = %i\n", h->iCloudWithSelectedPoint );
}


#endif