
#include <stdio.h>
#include <string.h>

void printHelp(FILE* f);

int main(int argc, char* argv[])
{ 
	FILE *f, *outf=stdout;
	
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
		char lineBuffer[1024];
		float x,y,z;

		while ( !feof(f) )
		{
			fgets(lineBuffer, 1023, f);
			if ( strstr(lineBuffer, "point") != NULL )
			{
				break;
			}
		} //while

		while ( !feof(f) )
		{
			fgets(lineBuffer, 1023, f);
			if ( strstr(lineBuffer, "]") != NULL )
			{
				break;
			}

			sscanf (lineBuffer, "%f %f %f", &x, &y, &z);
			fprintf(outf, "%f %f %f\n", x, y, z);
		} //while
	}

	{
		fclose(f);
		fclose(outf);
	}

	return 0;
}


void printHelp(FILE* f)
{
	fprintf(f, "[ABOUT] This program reads and converts wrl files using simple processing.\n[ABOUT] Usage: programName wrlPath outPath\n");
}