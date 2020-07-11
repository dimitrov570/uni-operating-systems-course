#include <err.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <sys/wait.h>


/*
	0. if strlen(argv[1]) == 1
	1. int limit=argv[1]-'0';
	2. char * cmd=argv[2];
	3. open logfile
		lastCond=0
		while(true)
			 fork
			 startTime
			exec
			wait(status)
			endTime
			writeToLog
			curCond = (WEXITSTATUS(status) != 0 && stopTime-startTime < limit );
		
			if (curCond == 1 && lastCon == 1)
			{
				exit
			}
			lastCond=curCond;
*/

int main(int argc, char *argv[])
{
	if(argc < 3)
	{
		errx(1, "Usage: %s <limit> <cmd> [<arg1> <arg2> ...]", argv[0]);
	}		

	if (strlen(argv[1]) != 1)
	{
		errx(2, "Expected digit in range [0, 9] as a first argument");
	}		
	

	int	limit = *argv[1] - '0';
	
	if ( limit < 0 || limit > 9)
	{
		
		errx(2, "Expected digit in range [0, 9] as a first argument");
	}

	char **cmd= argv + 2;
	
	int fd = open("run.log", O_CREAT | O_TRUNC | O_WRONLY, S_IRUSR | S_IWUSR | S_IRGRP);
	if (fd < 0)
	{
		err(3, "Cannot open logfile: run.log");
	}
	
	int lastCond=0;

	while(1)
	{	
		time_t startTime=time(NULL);
		int pid=fork();
		if(pid == -1)
		{
			err(4, "Error while forkind");//close fd
		}
		if(pid == 0)
		{
			if(execv(argv[2], cmd) < 0)
			{
				err(5, "Failed to exec: %s", argv[2]);// close fd
			}
		}
		int status;
		if (wait(&status) < -1) //close fd
		{
			err(6, "Cannot wait for the child to finish");
		}

		time_t endTime=time(NULL);		

		int exitCode;

		if (WIFEXITED(status))
		{
			exitCode=WEXITSTATUS(status);
		}
		else
		{
			exitCode=129;
		}
		
		char buf[3*sizeof(intmax_t) + 3];
		
		sprintf(buf, "%ld %ld %d\n", (intmax_t)startTime, (intmax_t)endTime, exitCode);

		if (write(fd, &buf, sizeof(buf)) != sizeof(buf)) //close fd
		{
			err(7, "Cannot write to logFile");
		}

		int curCond = (WEXITSTATUS(status)!=0 && ((endTime - startTime) < limit));
		if(curCond && lastCond)
		{
			break;
		}
		lastCond=curCond;
	}

	close(fd);

	exit(0);

}
