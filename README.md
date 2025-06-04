# Bash Academy

Learning bash scripting. I have used it to build in line pipelines for SysAdmin work, but want to get muscle memory with larger scripted pipelines. 

## Structure

I have some files including cheat sheets and aliases in the `notes/` directory. 

The `scripts/` directory includes some exercise problem statements with requirements as well as the implementation and any necessary files.

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