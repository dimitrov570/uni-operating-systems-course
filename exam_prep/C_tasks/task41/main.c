#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <err.h>
#include <stdint.h>
#include <stdio.h>
#include <errno.h>

int comparator(const void *a, const void *b)
{	
	if( *(uint16_t *)a > *(uint16_t *)b)
	{
		return 1;
	}
	else if ( *(uint16_t *)a < *(uint16_t *)b)
	{
		return -1;
	}
	return 0;
}

int main(int argc, char *argv[])
{
	if (argc != 3)
	{
		errx(1, "Usage: %s <inputFile> <outputFile>", argv[0]);
	}

	struct stat st;

	if(stat(argv[1], &st) == -1)
	{
		err(2, "Cannot stat file: %s", argv[1]);
	}

	int fileSize=st.st_size;

	if (fileSize % (int)sizeof(uint16_t) != 0)
	{
		errx(3, "Wrong file structure of input file");
	}	

	int fd_in = open(argv[1], O_RDONLY);

	if (fd_in < 0)
	{
		err(4, "Cannot open file: %s", argv[1]);
	}
	
	int fd_out = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC, 0644);

	if (fd_out < 0) //close fd_in
	{
		err(4, "Cannot open file: %s", argv[2]);
	}
	
	void *buff=malloc(fileSize);

	if (read(fd_in, buff, fileSize) != fileSize) //close fds
	{
		err(5, "Error while reading from file: %s", argv[1]);
	}
	
	qsort(buff, fileSize/2, sizeof(uint16_t), comparator);

	if (write(fd_out, buff, fileSize) != fileSize) //close fds
	{
		err(6, "Error while writing to file: %s", argv[2]);
	}

	close(fd_in);
	close(fd_out);
	free(buff);
	
	exit(0);
}
