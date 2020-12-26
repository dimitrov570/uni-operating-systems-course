#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <err.h>
#include <stdint.h>
#include <stdio.h>
#include <errno.h>


int main(int argc, char *argv[])
{
	if (argc != 5)
	{
		errx(1, "Usage:...");
	}

	struct stat st;
	
	if (stat(argv[1], &st) < 0)
	{
		err(2, "Cannot stat file");
	}
	
	int fileSize=st.st_size;

	if (fileSize > 0xFFFF)
	{
		warnx("File size bigger than max index size");
	}
	
	if (fileSize==0)
	{
		exit(0);
	}

	if(stat(argv[2], &st) < 0)
	{
		err(3, "Cannot stat file");
	}

	struct pack
	{
		uint16_t offset;
		uint8_t length;
		uint8_t fill;
	};

	struct pack tmp;

	if (st.st_size % sizeof(tmp) != 0)
	{
		errx(4, "Wrong file structure of input idx file");
	}

	int readSize;

	int fd1=open(argv[1], O_RDONLY); //err
	int fd2=open(argv[2], O_RDONLY); //err and close fds
	int fd3=open(argv[3], O_WRONLY | O_CREAT | O_TRUNC, 0644); //err and close fds
	int fd4=open(argv[4], O_WRONLY | O_CREAT | O_TRUNC, 0644); //err and close fds
	
	struct pack out;
	out.offset=0;

	while( (readSize=read(fd2, &tmp, sizeof(tmp))) == (size_t)sizeof(tmp) )
	{
		if(lseek(fd1,tmp.offset,SEEK_SET)<0)
		{
			//err
		}
		
		char *buff=malloc(tmp.length);

		if (read(fd1, buff, tmp.length) != tmp.length)//close fds, free buff
		{
			err(10, "Error while reading from input bin");
		}
		
		out.fill=tmp.fill;
		out.length=tmp.length;
		
		if (buff[0] < 'A' || buff[0] > 'Z')
		{
			free(buff);
			continue;
		}

		if (write(fd3, buff, tmp.length) != tmp.length) // CLOSE FDS, FREE BUFF
		{
			err(11,"Error while writting to output bin"); 
		}

		if (write(fd4, &out, sizeof(out)) < (ssize_t)sizeof(out))
		{
			err(12, "Error while writting to output idx"); //free buff, close fds
		}
		out.offset=out.offset+out.length;
		free(buff);
	}

	if (readSize == -1)
	{
		err(20, "Error while reading from input idx");
	}

		close(fd1);
		close(fd2);
		close(fd3);
		close(fd4);



	exit(0);
}
