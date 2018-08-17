# Service-Inspector
Simple powershell utility to check for active services against a previous snapshot of those. 

It consists of 2 .bat files (used to run the powershell scripts) and 2 .ps1 files with the actual scripts in them. Downlload all four file and put them in the same folder, as the batch are designed to run the scripts in the same folder. You can still use desktop shortcuts on those or launch them from the shell.

Use the .bat files to run the corresponding scripts, execution order should be ListGenerator.bat first, then Tester.bat.

ListGenerator-ps1 creates a folder called ServiceInspector under C:\. Then it creates a list of active services, which on its first start will be the master list, to be used with the tester to check which new services have been activated from that snapshot.

Tester.ps1 tests wether the active services are present in the chosen list (which can be different from the master list if ListGenerator has been launched multiple times). If not they are printed to screen.

The filepaths are designed with variables, to change the folder in which the lists are saved it's sufficient to assign to the $filepath variable  of both scripts the desired path.  



TO  DO LIST:
- Negative testing: check for services that have been disabled from list creation.
- Process tester: same thing but with windows processes.
