# terminal-working-env
This project includes some bash scripts to improve your terminal working efficiency

--
###Install <br/>
It's recommended to clone this project to ~/bin/ and source source.sh in your .bashrc file. <br/>
However, you can customize the path as you wish. <br/>

```  
cd ~/bin
git clone https://github.com/landicefu/terminal-working-env.git
echo "source ~/bin/terminal-working-env/source.sh" >> .bashrc
```
Note that you have to restart your terminal before the commands can be used, or you can simply execute following command to load the command.
```
source ~/.bashrc
```

--

Path Navigation Commands:
- godir <regex> <br/>
  Navigate to the source root of one of your large project. <br/>
  Execute "godir" to create index file named .filelist. <br/>
  Afterward, you can godir <regex> to navigate to files that matches the regular expression <br/>
  For example, <br/>
    godir LocationManager <br/>
    godir LocationManager.java <br/>
    godir landice/.*Activity.java <br/>
- croot <br/>
  After .filelist is created, you can use croot to change back to source root when you are in somewhere deep in your project folder

- lsp \<path_alias\>
- llp \<path_alias\>
- ldp \<path_alias\>

  lsp saves current path to a environment variable with a path alias that you can load with llp. <br/>
  ldp deletes the path alias.

  "llp list" lists the current path aliases in the environment variable. <br/>
  "llp slist <list_name>" saves all path aliases to a file later you can load them back. <br/>
  "llp llist <list_name>" loads all path aliases back from a file you saved with "llp slist". <br/>
  "llp dlist <list_name>" removes a saved path list file. <br/>
  "llp lslist" lists all the path list you can load with "llp llist". <br/>

  
  Note that <list_name> is not a filename. <br/>
  It's just a short name you can easily remember. <br/>
  The actual list file will be saved to ~/.path_alias
