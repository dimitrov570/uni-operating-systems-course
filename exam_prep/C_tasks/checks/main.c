#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/sysmacros.h>
#include <libgen.h>
#include <sys/wait.h>
#include <err.h>

int main()
{


	int fd=open("f1", O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);
		
	fprintf(stderr,"%d\n",fd);
	int fd2= dup2(fd,1);
	if(	write(fd, &fd, 4) < 4)
	{
		err(3,"Sdsds");
	}
	
	printf("fsdf");
	
	fprintf(stderr,"%d\n",fd2);
	
	close(fd2);
	close(fd);
	exit(0);
}
