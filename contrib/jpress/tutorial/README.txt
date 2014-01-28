SMART METER DEMO
----------------

This demo pack allows you to create an example kdb+ on-disk database containing smart meter data. 
The idea is to give you a taste of the performance of kdb+ and the q language. 
Please experiment with kdb+ and the functions provided. 
Resources are available at 

http://code.kx.com
 
It has been designed to run with the free 32 bit download, so care has been taken to constrain
memory usage. Better performance is possible with the licenced 64 bit version.   

There are 4 scripts:

buildsmartmeterdb.q 	: used to build an example database
smartmeterdemo.q 	: start the database and run the functions
tutorial.q 		: functions to run the tutorial (loaded by smartmeterdemo.q)
smartmeterfunctions.q 	: functions to analyze the smart meter data (loaded by smartmeterdemo.q)

There are two steps:

1. Build the database
---------------------

To build the database, run 

q buildsmartmeterdb.q

You can modify aspects of the database at the top of the buildsmartmeterdb.q script, for example
the number of days to build, the number of customers, the database directory etc.

The script will print a series of instructions and notes.  Once you are happy, build the database using

go[]

The process will exit when complete.

2. Run the demo script
----------------------

To run the demo script, use

q smartmeterdemo.q

If you modified the database directory from the default specified in buildsmartmeter.q, then you will need
to launch the script specifying the new path e.g.

q smartmeterdemo.q /my/new/path/to/database

Again, a series of notes and instructions will be printed.  Step through the demo.
You should experiment with running the functions with different parameters (be careful of 32 bit memory limits)
and running the database with and without slaves.  Using slaves will increase the memory usage.  To start with
slaves use:

q smartmeterdemo.q -s [number of slaves]
