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
#include <errno.h>

int main(int argc, char* argv[])
{
	if(argc != 2)
	{
		errx(1,"Usage: %s <fileName>", argv[0]);
	}
	
	int fd=open(argv[1], O_WRONLY | O_TRUNC | O_CREAT, S_IRUSR | S_IWUSR | S_IRGRP);
	if (fd == -1)
	{
		errx(2,"Cannot open file: %s", argv[1]);
	}
	
	char message1[]="foo";
	char message2[]="bar";
	
	if(write(fd, &message1, 2) != 2)
	{
		int olderrno=errno;
		close(fd);
		errno=olderrno;

		err(3,"Error while writing");
	}
	
	int pid = fork();

	if(pid == -1)
	{
		int olderrno=errno;
		close(fd);
		errno=olderrno;

		err(4,"Error while forking");
	}

	if(pid == 0)
	{
		int written;
		if((written=(write(fd,&message2,4)) < 0))
		{
			int olderrno=errno;
			close(fd);
			errno=olderrno;
		
			err(5,"Error while writing");
		}
		exit(0);
	}
	else
	{
		wait(NULL);
		write(fd, message1 + 2, 2);
	}
	return 0;
}
