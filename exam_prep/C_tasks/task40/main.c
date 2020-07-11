#include <stdio.h>
#include <err.h>
#include <string.h>

int main(int argc, char *argv[])
{
	if (argc != 3 && argc != 5)
	{
		errx(1, "Wrong nr of args");
	}

	if ( argc == 3 )
	{
		if (strcmp(argv[1], "-c"))
		{
			if(strlen(argv[2]) == 1)
			{
				int field=argv[2] - '0';
				

			}
		}
	}






	exit(0);
}
