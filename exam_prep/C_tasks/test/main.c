#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <time.h>
int main()
{
	srand(time(NULL));
	int tm=rand()%9;

	int exitStatus=rand()%255;

	printf("sleep for %d seconds and exit with %d\n", tm, exitStatus);

	sleep(tm);

	exit(exitStatus);
}
