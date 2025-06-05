# Steps to run a assembly test
Clone the repo and run
   ```
   cd Shakti-IITM/AssemblyTest/
   ```
To get the disass and run the elf on spike
   ```
   make run TEST=<path/to/test>
   ```
To only run the elf on spike
   ```
   make spike TEST=<path/to/test>
   ```
To generate the disassembly file
   ```
   make disasm TEST=<path/to/test>
   ```

