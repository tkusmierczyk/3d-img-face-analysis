
#include "ChBinStructs.h"
#include <stdio.h>
#include <string.h>

void storePoint(FILE* f, sCloudPoint_v10* pt, 
				sSingleCloudBinaryHeader_v10* cloud,
				sCloudsBinaryHeader_v10* header);
void printHelp(FILE* f);

int main(int argc, char* argv[])
{ 
	FILE *f, *outf=stdout;
	sCloudsBinaryHeader_v10 header;
	sSingleCloudBinaryHeader_v10 cloudHeader;
	sCloudPoint_v10 point;
	
	/*Args processing:*/
	if (argc <= 1)
	{	
		printHelp(stderr);
		fprintf(stderr, "One argument (input file path) is obligatory!\n");
		return -1;
	}

	{
		f = fopen(argv[1], "rb");
		if (f==NULL)
		{
			fprintf(stderr, "Failed opening file: %s!\n", argv[1]);
			return -1001;
		}
	}

	if (argc >= 3)
	{
		outf = fopen(argv[2], "w");
		if (outf == NULL)
		{
			fprintf(stderr, "Failed opening file {%s} to write!\n", argv[2]);
			return -2;
		}
	} else
	{	/*auto create*/
		char outFilePath[1024];
		char* dotPos;

		strncpy(outFilePath, argv[1], 1023);
		dotPos = strrchr(outFilePath, '.');
		if (dotPos == NULL)
		{
			dotPos = strrchr(outFilePath, '\0');
		}
		strcpy(dotPos, ".txt\0");

		outf = fopen(outFilePath, "w");
		if (outf == NULL)
		{
			fprintf(stderr, "Failed opening file {%s} to write!\n", outFilePath);
			return -2;
		}
	}

	/*Conversion:*/
	{
		fread(&header, sizeof(header), 1, f);
		fprintfChBinHeader(stdout, &header);
		{
			unsigned int cloudNo, pointNo;			
			for (cloudNo=0; cloudNo<header.uiCloudCount; ++cloudNo)
			{
				fprintf(stdout, "[Cloud no:%i]:\n", cloudNo);
				fread(&cloudHeader, sizeof(cloudHeader), 1, f);
				fprintfChBinCloudHeader(stdout, &cloudHeader);

				for (pointNo=0; pointNo<cloudHeader.uiCount; ++pointNo)
				{
					if (feof(f))
					{
						fprintf(stderr, "Unexpected EOF!\n");
						break;
					}
					
					fread(&point, sizeof(point), 1, f);
					storePoint(outf, &point, &cloudHeader, &header);
					/*fprintf(stdout, "Point no %i:", pointNo);
					fprintfChBinPoint(stdout, &point);*/
				} /*for*/
			} /*for*/
		}
	}

	{
		fclose(f);
		fclose(outf);
	}

	return 0;
}

void storePoint(FILE* f, sCloudPoint_v10* pt, 
				sSingleCloudBinaryHeader_v10* cloud,
				sCloudsBinaryHeader_v10* header)
{
	fprintf(f, "%f %f %f\n", pt->x, pt->y, pt->z);
	/*fprintf(f, "%f %f %f  %d %d %d\n", pt->x, pt->y, pt->z, pt->r, pt->g, pt->b);*/
}

void printHelp(FILE* f)
{
	fprintf(f, "[ABOUT] This program reads and converts chbin files.\n[ABOUT] Usage: programName chBinPath outPath\n");
}