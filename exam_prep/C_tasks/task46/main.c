#include <err.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>



int main(int argc, char *argv[])
{

	if (argc > 2)
	{
		errx(1, "Usage: %s <cmd>", argv[0]);
	}
//	if argc == 1 char cmd[]="echo"
	else if (argc == 1)
	{
		//char cmd[]="echo";
	}
	else
	{
//	else char *cmd=argv[1]
		//char *cmd=argv[1];		
	}

	char args1[5];
	char args2[5];
	int nrArg=0;
	while(1)
	{
		nrArg=0;
		int i=0;
		int rSize=0;
		int notFull=0;
		while(i<4)
		{
			if ((rSize=read(1,&args1[i], 1)) < 0)
			{
				err(2, "Error while reading from stdin");
			}
			else if (rSize == 0)
			{
				break;
			}
			if (args1[i] == 0x20 || args1[i] == 0x0A )
			{
				args1[i] = '\0';
				notFull = 1;
				break;
			}
			i++;
		}
		args1[4]='\0';

		if (!i)
		{
			break;
		}
		else
		{
			nrArg=1;
		}

		char c;

		if(!notFull)
		{
			if(read(1, &c, 1) < 0)
			{
				err(2, "Error while reading from stdin");
			}
			if ( c != 0x20 && c != 0x0A )
			{
				errx(3, "Invalid length of parameters!");
			}
		}
		
		notFull=0;

		int j=0;
		
		while(j<4)
		{
			if ((rSize=read(1,&args2[j], 1)) < 0)
			{
				err(2, "Error while reading from stdin");
			}
			else if (rSize == 0)
			{
				break;
			}
			if (args2[j] == 0x20 || args2[j] == 0x0A || args2[j] == EOF)
			{
				args2[j] = '\0';
				notFull=1;
				break;
			}
			j++;
		}
		args2[4]='\0';
		
		if (!i)
		{
			break;
		}
		else
		{
			nrArg=2;
		}
		if(!notFull)
		{
			if(read(1, &c, 1) <0)
			{
				err(2, "Error while reading from stdin");
			}
			if ( c != 0x20 && c != 0x0A )
			{
				errx(3, "Invalid length of parameters!");
			}
		}

		if(nrArg==1)
		{
			printf("exec with 1 param\n");
			exit(0);
		}
		else
		{
			printf("exec with 2 params\n");
		}

	}
// 	if (read(1, &args1[i], 1) < 0)
//  err
// 	argNr=1;
// 	if (args1[i] == 0x20 || args1[i] == 0x0A)
//		args[i] == '\0';
//		int notFull=1;
//		break;
//		++i
//  if (!i) break;
//	repeat reading;
//	int j=0;
//  ....
//  if (!j) exec with args1 only;
//	else exec with args1 args2;

	exit(0);
}
