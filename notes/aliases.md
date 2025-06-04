# Useful bash aliases

Add these to your `.bashrc` or `.bash_aliases` file and source them in your home directory.

## Extracting Fields for Awk from Logfile:

```bash
alias fields='awk '\''{for(i=1; i<=NF; i++) printf "F%d:[%s] ", i, $i; print ""}'\'''
```