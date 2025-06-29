# Bash Academy

Learning bash scripting. I have used bash to build in-line pipelines for SysAdmin work, but want to get muscle memory with larger scripted pipelines. 

So, in order to level up my skills I started a Claude project with some background instruction to help me practice some DevOps skills and provide me with sample exercises to help learn in a project-based method. 

## Structure

I have some files including cheat sheets and aliases in the `notes/` directory. 

The `scripts/` directory includes folders containing the artifacts related to each practice exercise. 

The `README.md` in each directory explains the problem and was generated with Claude Sonnet 4. Some projects include log files or other artifacts that are also generated by Claude. All bash solution code was written by me.

## Running Scripts in Docker containers

Using docker containers is helpful for maintaining a consistent environment which eliminates the issue of certain utilities (like `free`) not being available on MacOS.

Below are some simple commands to help with my learning workflow.

### Quick Testing
```bash
# Run scripts in a Linux container with files mounted
docker run --rm -it -v "$(pwd)":/workspace -w /workspace ubuntu:latest bash

# Inside the container, run scripts normally:
./scripts/Apache\ Log\ Parser/failed_logins.sh
./scripts/system_monitor.sh -d 75 -v
```

### Alternative: Persistent Container
```bash
# Create a long-running container
docker run --name bash-practice -d -v "$(pwd)":/workspace -w /workspace ubuntu:latest tail -f /dev/null

# Connect to it anytime
docker exec -it bash-practice bash

# Clean up when done
docker rm -f bash-practice
```

## Development Environment

I'm using an old MacBook Pro for development. Running VSCode with the `shellcheck` extension for avoiding syntax and formatting errors.