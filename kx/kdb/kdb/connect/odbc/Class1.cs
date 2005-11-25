// csc class1.cs /r:"/program files/microsoft.net/odbc.net/microsoft.data.odbc.dll"
using System;
using System.Data;
using System.IO;
using Microsoft.Data.Odbc;

namespace AKdbTest {
	class Class1 {
		[STAThread]
		static void Main() {
			Console.WriteLine("Connecting to Kdb...");

			OdbcConnection oConn = new OdbcConnection("dsn=//");

			try {
				oConn.Open();
			}
			catch(Exception e) {
				Console.WriteLine(e);
			}

			OdbcDataAdapter da = new OdbcDataAdapter("$select distinct stock from trade", oConn);
			DataTable dt = new DataTable();

			try {
				da.Fill(dt);
			}
			catch(Exception e) {
				Console.WriteLine(e);
			}
			finally {
				oConn.Close();
			}

			Console.WriteLine("Press 'Enter' key to quit.");
			string s = Console.ReadLine();
		}
	}
}
