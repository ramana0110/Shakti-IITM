# Steps to run a assembly test
1. Clone the Shakti C class repo and build the core and also install the dependencies 
2. In the c-class directory go to risc-v tests -> isa -> risc-v extension you want to use and create a new assembly file
3. Follow the format used in the existing assembly tests to write your assembly test
4. For assembling and running the assembly code on spike and core go back to the c-class directory and use the following command
   <pre>
   make test opts='--test={name of your test file} --suite={suite folder} --debug' CONFIG_ISA={ISA extension}
   </pre>
      ## For example:
         make test opts='--test=rem_test --suite=rv64um --debug' CONFIG_ISA=RV64IMAFDC_zifencei
