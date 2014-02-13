Quick Start
-----------

To launch a process wrapped in the framework, you need to set the environment variables and give the process a type and name.  The type and name can be explicitly passed on the command line.  setenv.sh is an example of how to set the environment variables on a unix type system.  For a windows system, see http://www.computerhope.com/issues/ch000549.htm. 

To avoid standard out/err being redirected, used the -debug flag

./setenv.sh  		/- Assuming unix type OS
q torq.q -proctype test -procname mytest -debug

To load a file, use -load

q torq.q -load mytest.q -proctype test -procname mytest -debug

This will launch the a process running within the framework with all the default values.  For the rest, read the document!
