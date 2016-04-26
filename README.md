# terminal-working-env
This project includes some bash scripts to improve your terminal working efficiency

Path Navigation Commands:
- godir <regex>

  Navigate to the source root of one of your large project.
  Execute "godir" to create index file named .filelist.
  Afterward, you can godir <regex> to navigate to files that matches the regular expression
  For example,
    godir LocationManager
    godir LocationManager.java
    godir landice/.*Activity.java
- croot

  After .filelist is created, you can use croot to change back to source root when you are in somewhere deep in your project folder

- lsp \<path_alias\>
- llp \<path_alias\>
- ldp \<path_alias\>

  lsp saves current path to a environment variable with a path alias that you can load with llp.

  ldp deletes the path alias.

  "llp list" lists the current path aliases in the environment variable.

  "llp slist <list_name>" saves all path aliases to a file later you can load them back.
  
  "llp llist <list_name>" loads all path aliases back from a file you saved with "llp slist".
  
  "llp dlist <list_name>" removes a saved path list file.
  
  "llp lslist" lists all the path list you can load with "llp llist".

  
  Note that <list_name> is not a filename.
  It's just a short name you can easily remember.
  The actual list file will be saved to ~/.path_alias
