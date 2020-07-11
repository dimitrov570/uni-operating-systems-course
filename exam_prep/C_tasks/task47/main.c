#include <stdio.h>
#include <err.h>
#include <unistd.h>
#include <sys/types.h>
#include <stdlib.h>
#include <sys/wait.h>

//   find | sort -n | tail -n 1 | cut -d ' ' -f 2
//       p1			p2			p3		
//      1 | 0     1 | 0       1 | 0

int main(int argc, char *argv[])
{
	if (argc != 2)
	{
		errx(1, "Usage: %s <dirname>", argv[0]);
	}


	int p1[2];

	if(pipe(p1)<0)
	{
		err(2, "Error while creating pipe!");
	}	
	
	int pid_find = fork();
	
	if (pid_find == -1)
	{
		err(3,"Could not fork!");
	}
	
	if (pid_find == 0)
	{
			close(p1[0]);
			if(dup2(p1[1], 1)<0)
			{
				err(5,"Cannot dup");
			}
			if (execlp("find", "find", argv[1], "-type", "f", "-printf", "%T@ %p\n", (char*)NULL) < 0)
			{
				err(4, "Error while executing command find");
			}	
	}
	
	close(p1[1]);
	
	int p2[2];

	if(pipe(p2)<0)
	{
		err(2, "Error while creating pipe!");
	}

	int pid_sort = fork();

	if (pid_sort == -1)
	{
		err(3,"Could not fork!");
	}
	
	if (pid_sort == 0)
	{
			close(p2[0]);
			if(dup2(p2[1], 1)<0)
			{
				err(5,"Cannot dup");
			}
			if(dup2(p1[0],0)<0)
			{
				err(5,"Cannot dup");
			}
			if (execlp("sort", "sort", "-n", (char*)NULL) < 0)
			{
				err(4, "Error while executing command sort");
			}	
	}

	close(p1[0]);
	close(p2[1]);

	int p3[2];

	if(pipe(p3)<0)
	{
		err(2, "Error while creating pipe!");
	}

	int pid_tail = fork();

	if (pid_tail == -1)
	{
		err(3,"Could not fork!");
	}
	
	if (pid_tail == 0)
	{
			close(p3[0]);
			if(dup2(p3[1], 1) < 0)
			{
				err(5,"Cannot dup");
			}
			if(dup2(p2[0],0) < 0)
			{
				err(5,"Cannot dup");
			}
			if (execlp("tail", "tail", "-n", "1", (char*)NULL) < 0)
			{
				err(4, "Error while executing command tail");
			}	
	}

	close(p2[0]);
	close(p3[1]);
	
	int pid_cut = fork();

	if (pid_cut == -1)
	{
		err(3,"Could not fork!");
	}
	
	if (pid_cut == 0)
	{
			if(dup2(p3[0], 0)<0)
			{
				err(5,"Cannot dup");
			}
			if (execlp("cut", "cut", "-d ", "-f2", (char*)NULL) < 0)
			{
				err(4, "Error while executing command cut");
			}	
	};

	wait(NULL);
	wait(NULL);
	wait(NULL);
	wait(NULL);

	close(p3[0]);

	exit(0);
}
