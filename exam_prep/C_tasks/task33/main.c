//split input file data into two temporary files, so RAM won't be exceeded
//sort two temporary files and merge them into output file

#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <err.h>
#include <stdint.h>
#include <stdio.h>
#include <errno.h>

int comparator(const void * a, const void * b)
{
	if( *(uint32_t *)a > *(uint32_t *)b)
	{
		return 1;
	}
	else if ( *(uint32_t *)a < *(uint32_t *)b)
	{
		return -1;
	}
	return 0;
}

int main(int argc, char *argv[])
{
	if(argc != 2)
	{
		errx(100, "Wrong number of arguments!");
	}	
	
	struct stat st;

	if (stat(argv[1], &st) == -1)
	{
		err(1, "Cannot stat file \"%s\"!", argv[1]);
	}
		
	int fileSize = st.st_size;	

	if (fileSize <= (int)sizeof(uint32_t))
	{
		exit(0);
	}	
	
	if ( fileSize % sizeof(uint32_t) )
	{
		errx(2, "Wrong file structure!");
	}

	int fd1 = open(argv[1], O_RDONLY);
	
	if(fd1 < 0)
	{
		err(3, "Cannot open file \"%s\"!", argv[1]);
	}
	
	int numOfNr=fileSize/sizeof(uint32_t);

	int nrElem1=numOfNr/2;
	int nrElem2=numOfNr-nrElem1;
	int size1=nrElem1*sizeof(uint32_t);
	int size2=nrElem2*sizeof(uint32_t);
	
	uint32_t *buff=malloc(size1);
	
	if(!buff)
	{	
		int olderrno=errno;
		close(fd1);
		errno=olderrno;
		err(4, "Cannot allocate memory!");
	}
	
	int tmp1=open("tmp1", O_CREAT| O_TRUNC | O_RDWR, S_IRUSR | S_IWUSR);
	if(tmp1<0)
	{
		int olderrno=errno;
		close(fd1);
		free(buff);
		errno=olderrno;
		err(5, "Cannot create tmp file!");
	}	
		
	if (read(fd1, buff, size1) != size1)
	{	
		int olderrno=errno;
		close(fd1);
		close(tmp1);
		free(buff);
		errno=olderrno;
		err(6, "Error while reading file \"%s\"!", argv[1]);
	}
	
	qsort(buff, nrElem1, sizeof(uint32_t), comparator);
	
	if (write(tmp1, buff, size1) != size1)
	{	
		int olderrno=errno;
		close(fd1);
		close(tmp1);
		free(buff);
		errno=olderrno;
		err(7, "Error while writing to tmp file!");
	}

	free(buff);
	
	buff=malloc(size2);

	if(!buff)
	{	
		int olderrno=errno;
		close(fd1);
		close(tmp1);
		errno=olderrno;
		err(8, "Cannot allocate memory!");
	}

	int tmp2=open("tmp2", O_CREAT| O_TRUNC | O_RDWR, S_IRUSR | S_IWUSR);
	if(tmp2<0)
	{
		int olderrno=errno;
		close(fd1);
		close(tmp1);
		free(buff);
		errno=olderrno;
		err(9, "Cannot create tmp file!");
	}	

	if (read(fd1, buff, size2) != size2)
	{	
		int olderrno=errno;
		close(fd1);
		close(tmp1);
		close(tmp2);
		free(buff);
		errno=olderrno;
		err(10, "Error while reading file \"%s\"!", argv[1]);
	}
	
	qsort(buff, nrElem2, sizeof(uint32_t), comparator);
	
	if (write(tmp2, buff, size2) != size2)
	{	
		int olderrno=errno;
		close(fd1);
		close(tmp1);
		close(tmp2);
		free(buff);
		errno=olderrno;
		err(11, "Error while writing to tmp file!");
	}

	free(buff);
	close(fd1);

	lseek(tmp1,0,SEEK_SET);
	lseek(tmp2,0,SEEK_SET);
	
	int fd2=open("output", O_CREAT | O_WRONLY | O_TRUNC, S_IWUSR | S_IRUSR | S_IRGRP);
	if(fd2<0)
	{
		int olderrno=errno;
		close(tmp1);
		close(tmp2);
		free(buff);
		errno=olderrno;
		err(12, "Cannot create tmp file!");
	}	

	uint32_t first;
	uint32_t second;
	while ((read(tmp1,&first,sizeof(first)) == sizeof(first)) && (read(tmp2,&second,sizeof(second)) == sizeof(second)))
	{
		if (first <= second)
		{
			write(fd2, &first, sizeof(first));
			lseek(tmp2, -1*sizeof(first), SEEK_CUR);
		}
		else
		{
			write(fd2, &second, sizeof(second));
			lseek(tmp1, -1*sizeof(second), SEEK_CUR);
		}
	}

	while(read(tmp1,&first,sizeof(first)) == sizeof(first))
	{
		write(fd2, &first, sizeof(first));	
	}


	while(read(tmp2,&second,sizeof(second)) == sizeof(second))
	{
		write(fd2, &second, sizeof(second));	
	}

	exit(0);
}
