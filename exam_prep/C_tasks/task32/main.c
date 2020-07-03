#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <err.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <stdint.h>

int main()
{

	struct pairXY 
	{
		uint32_t x;
		uint32_t y;
	};

	uint64_t f1_size;
	uint64_t f2_size;

	struct stat st;

	if (stat("f1",&st) < 0)
	{
		err(2, "Can't stat file \"f1\"");
	}

	f1_size=st.st_size;

	if ( f1_size == 0 || f1_size % sizeof(struct pairXY) != 0)
	{
		errx(3, "File \"f1\" is empty or not in right format!");
	}


	if (stat("f2",&st) < 0)
	{
		err(4, "Can't stat file \"f2\"");
	}

	f2_size=st.st_size;

	if ( f2_size == 0 || f1_size % sizeof(uint32_t) != 0)
	{
		errx(5, "File \"f1\" is empty or not in right format!");
	}

	int fd1;
	int fd2;
	int fd3;


	fd1 = open("f1", O_RDONLY);
	if (fd1 == -1)
	{
		err(6, "Can't open file: \"f1\"");
	}


	fd2 = open("f2", O_RDONLY);
	if (fd2 == -1)
	{
		int olderrno=errno;
		close(fd1);
		errno=olderrno;
		err(7, "Can't open file: \"f2\"");
	}


	fd3 = open("f3", O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP);
	if (fd3 == -1)
	{
		int olderrno=errno;
		close(fd1);
		close(fd2);
		errno=olderrno;
		err(8, "Can't open file: \"f3\"");
	}


	//if()
	struct pairXY pair;
	while (read(fd1, &pair, sizeof(pair)))
	{
		if( lseek(fd2, pair.x*sizeof(uint32_t), SEEK_SET) == -1 )
		{	
			int olderrno=errno;
			close(fd1);
			close(fd2);
			close(fd3);
			errno=olderrno;
			err(9, "Out of range of file \"f2\"");
		}

		uint32_t length=pair.y;
		uint32_t buffer;

		while(length>0 && read(fd2, &buffer, sizeof(buffer)))
		{
			write(fd3, &buffer, sizeof(buffer));
			length--;
		}
	}


	close(fd1);
	close(fd2);
	close(fd3);
	exit(0);
}
