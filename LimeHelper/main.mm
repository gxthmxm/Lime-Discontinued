#include <spawn.h>
#include <signal.h>
#include <unistd.h>
#include <sys/sysctl.h>
#include <mach/mach.h>

int main(int argc, char **argv, char **envp) {
	int mib[3] = { CTL_KERN, KERN_PROC, KERN_PROC_ALL};
	struct kinfo_proc *info;
	size_t length;
	if (sysctl(mib, 3, NULL, &length, NULL, 0) < 0) return -1;
	if (!(info = (struct kinfo_proc *)malloc(length))) return -1;
	if (sysctl(mib, 3, info, &length, NULL, 0) < 0) {
		free(info);
		return -1;
	}
	pid_t pid = getppid();
	static int maxArgumentSize = 0;
	if (maxArgumentSize == 0) {
	size_t size = sizeof(maxArgumentSize);
	if (sysctl((int[]){ CTL_KERN, KERN_ARGMAX }, 2, &maxArgumentSize, &size, NULL, 0) == -1) {
		perror("sysctl argument size");
		 maxArgumentSize = 4096; // Default
		}
	}
	if (pid == 0) return 0;
	size_t size = maxArgumentSize;
	char *buffer = (char *)malloc(length);
	if (sysctl((int[]){ CTL_KERN, KERN_PROCARGS2, pid }, 3, buffer, &size, NULL, 0) == 0) {
		NSString *executable = @(buffer + sizeof(int));
		NSRange range = [executable rangeOfString:@"/" options:NSBackwardsSearch];
		if(range.location != NSNotFound) executable = [executable substringFromIndex:range.location + 1];
		if(![executable isEqualToString:@"Lime"]) {
			printf("as Jay already said, YOU SHALL NOT PASS\n");
			return -1;
		}
		setuid(0);
		pid_t aptPid;
        	int status;
		const char *path[] = {"PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11:/usr/games", NULL};
        	posix_spawn(&aptPid, "/usr/bin/apt-get", NULL, NULL, (char**)argv, (char**)path);
        	waitpid(aptPid, &status, 0);
		return status;
	}
	return -1;
}
