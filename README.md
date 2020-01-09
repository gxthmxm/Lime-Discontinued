# Lime
Deadline: Summer 2020?

## Build
Set the Environment Variables for your device's IP  
**ZSH**  
```echo "export LIMEIP=*ip*" >> ~/.zprofile```  
**Bash**  
```echo "export LIMEIP=*ip*" >> ~/.bash_profile```  
Now re-open your shell, navigate to the Lime directory and run ```make compile```

# Important Classes
List of important classes, how to use them and how they work.

## LMPackageManager
Manages all the packages, parses files and so on.
**Methods**
```objectivec
+ (NSMutableArray *)installedPackages; // returns a list of LMPacakge's with all installed packages
```
