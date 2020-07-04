#include <stdio.h>
#include <stdlib.h>
#include <err.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/types.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>

int comparator(const void *a, const void *b) {
  return *(char*)a - *(char*)b;
}

int main(int argc, char* argv[])
{
	if (argc != 2 && argc != 3) 
	{
			errx(1, "Wrong number of arguments!");
	}
	
	struct stat st;
	
	if ( stat(argv[1], &st) == -1 )
	{
		err(10, "Cannot stat file %s", argv[1]);
	}

	u_int32_t fileSize = st.st_size; 
	
	if (!fileSize)
	{
		exit(0);
	}

	int fd1 = open(argv[1], O_RDWR);

	if (fd1 == -1)
	{
		err(1, "Cannot open file %s", argv[1]);
	}	

	//printf("%d\n", fileSize);
	
	void *buffer=malloc(fileSize);
	
	if(!buffer)
	{
		int olderrno=errno;
		close(fd1);
		errno=olderrno;
		errx(20, "Failed to allocate buffer memory!");
	}

	if ( fileSize != read(fd1, buffer, fileSize) )
		{
			int olderrno=errno;
			close(fd1);
			errno=olderrno;
			free(buffer);
			err(3,"Error while reading!");
		}
	
	qsort(buffer, fileSize, 1, comparator);
	
	int fd_write;

	if (argc == 3)
	{
		fd_write = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC, S_IWUSR | S_IRUSR);

		if (fd_write == -1)
		{
			err(2, "Cannot open file %s", argv[2]);
		}	
	}
	else
	{
		fd_write=fd1;
	}

	if ( fileSize != write(fd_write, buffer, fileSize) )
		{
			int olderrno=errno;
			close(fd1);
			
			if(argc==3)
			{
				close(fd_write);
			}	
			
			errno=olderrno;
			free(buffer);
			err(4, "Error while writing!");
		}
	free(buffer);
	close(fd1);
	if(argc==3)
		{
			close(fd_write);
		}	
	exit(0);
}
