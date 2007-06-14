var lastTableNumber;
var lastColumnNumber;
var lastOrder;

function sortTableRows ()
{
	// get all tables in this document
	tables = document.getElementsByTagName ('table');

	// iterate through all the tables, to make the tables sortable
	for (var tableNumber = 0; tableNumber < tables.length; tableNumber++)
	{
		// check if the table uses the thead-element
		var thead = tables[tableNumber].getElementsByTagName ('thead');
		if (thead.length > 0) var headerRow = thead[0].getElementsByTagName ('tr')[0];
		// if not, use the first row of this table as header
		else var headerRow = tables[tableNumber].getElementsByTagName ('tr')[0];

		// iterate through all the th-elements, to add the onclick event with the 'sortColumn'-function attached
		tableHeaders = headerRow.getElementsByTagName ('th');
		for (var columnNumber = 0; columnNumber < tableHeaders.length; columnNumber++)
		{
			// attach the 'sortColumn'-function
			if (!document.all && document.getElementById)
			{
				// this method works fine in Mozillla, but IE doesn't do anything, really.
				// It's a pity, 'cause when using the setAttribute-function you can style
				// the element with CSS using:
				//     th[onclick] { /* some properties here */ }
				tableHeaders[columnNumber].setAttribute ('onclick', 'sortColumn(' + tableNumber + ', ' + columnNumber + ');');
			}
			else if (document.all && document.getElementById)
			{
				tableHeaders[columnNumber]['onclick'] = new Function ('sortColumn(' + tableNumber + ', ' + columnNumber + ')');
				//tableHeaders[columnNumber].style.cursor = 'hand';
			}
		}
	}
}

function sortColumn (tableNumber, columnNumber)
{
	// set some variables we're going to use
	var rowData = new Array ();
	var rowDataSorted = new Array ();
	var rowToBeRemoved = new Array ();
	var rowToBeInserted = new Array ();
	var table, rows, order;

	// check wheter it should be ordered ascending or descending
	if (lastTableNumber == tableNumber && lastColumnNumber == columnNumber)
	{
		if (lastOrder == 'ascending') order = 'descending';
		else if (lastOrder == 'descending') order = 'ascending';
	}
	else order = 'ascending';

	// in case there is a tbody-element, we'll use the rows nested in this element ...
	table = document.getElementsByTagName ('table')[tableNumber];
	tbody = table.getElementsByTagName ('tbody');
	if (tbody.length > 0)
	{
		var tbody = table.getElementsByTagName ('tbody')[0];
		var firstRow = 0;
	}
	// ... otherwise we'll use the rows that are directly nested in the table-element, starting with the second (assuming the first row is the header)
	else
	{
		var tbody = table;
		var firstRow = 1;
	}

	// put all the rows in an array, so we can access each easily
	rows = tbody.getElementsByTagName ('tr');

	// iterate through the rows, and put the data according to which the table must be sorted in an array
	for (var rowNumber = firstRow; rowNumber < rows.length; rowNumber++)
	{
		data = rows[rowNumber].getElementsByTagName ('td')[columnNumber].firstChild.nodeValue;
		rowData[rowData.length] = new Array (rowNumber, data);
	}

	// choose the relevant sorting method, according to the first row:
	//   - the data is numeric
    if (rowData[0][1].match(/^\s*\d*\.*\d*\s*$/)) rowDataSorted = rowData.sort (numeric);
	//   - no particular type of data recognized, use the standard sorting-method
	else rowDataSorted = rowData.sort (normal);

	// iterate through the rows, that now are in the correct order ...
	for (var x = 0; x < rowDataSorted.length; x++)
	{
		originalRow = rows[(rowDataSorted[x][0])];
		// ... create a clone of the orignal row, and register it to be inserted in its new place ...
		rowToBeInserted[rowToBeInserted.length] = originalRow.cloneNode (true);
		// ... and register the original row to be removed, because its place isn't correct anymore
		rowToBeRemoved[rowToBeRemoved.length] = originalRow;
	}

	// reverse order if we sort this column descending
	if (order == 'descending') rowToBeInserted.reverse ();

	// insert the clones into the table's body
	for (var x = 0; x < rowToBeInserted.length; x++)
	{
		// the following two lines are for the alternate row colorrowToBeInserted[x].getAttribute ('class') + 
		if (x%2)
		{
			var oldClass = rowToBeInserted[x].getAttribute ('class');
			oldClass = oldClass.replace ('odd', '');
			oldClass = oldClass.replace ('even', '');
			rowToBeInserted[x].setAttribute ('class', oldClass + ' even');
		}
		else
		{
			var oldClass = rowToBeInserted[x].getAttribute ('class');
			oldClass = oldClass.replace ('odd', '');
			oldClass = oldClass.replace ('even', '');
			rowToBeInserted[x].setAttribute ('class', oldClass + ' odd');
		}

		tbody.appendChild (rowToBeInserted[x]);
	}
	// remove the original, now superfluous, rows
	for (var x = 0; x < rowToBeRemoved.length; x++)
	{
		tbody.removeChild (rowToBeRemoved[x]);
	}

	// register a class to the header of the column according to which the table has been sorted, so one can style a ascending and descending sorted column differently
	// check if the table uses the thead-element
	if (thead = tables[tableNumber].getElementsByTagName ('thead')) headerRow = thead[0].getElementsByTagName ('tr')[0];
	// if not, use the first row of this table as header
	else headerRow = tables[tableNumber].getElementsByTagName ('tr')[0];

	// iterate through all the th-elements, to add the onclick event with the 'sortColumn'-function attached
	tableHeaders = headerRow.getElementsByTagName ('th');
	for (var columnNumberTwo = 0; columnNumberTwo < tableHeaders.length; columnNumberTwo++)
	{
		if (columnNumberTwo == columnNumber) tableHeaders[columnNumberTwo].setAttribute ('class', order);
		else tableHeaders[columnNumberTwo].setAttribute ('class', '');
	}
	
	// remember according to which column from which table we've sorted, and in what order, so when one sorts this column again, we sort it in reverse order
	lastTableNumber = tableNumber;
	lastColumnNumber = columnNumber;
	lastOrder = order;
}

function numeric (foo, bar)
{
	valueOne = foo[1];
	valueTwo = bar[1];
	return valueOne - valueTwo;
}

function normal (foo, bar)
{
	x = new Array (foo[1], bar[1]);
	x.sort ();
	if (x[0] == foo[1]) return -1;
	else if (x[0] == x[1]) return 0;
	else return 1;
}

function alternateRowColors ()
{
	tables = document.getElementsByTagName ('table');
	for (x = 0; x < tables.length; x++)
	{
		if (tbody = tables[x].getElementsByTagName ('tbody')) rows = tbody[0].getElementsByTagName ('tr');
		else rows = tables[x].getElementsByTagName ('tr');

		for (i = 0; i < rows.length; i++)
		{
			if (i%2) rows[i].setAttribute ('class', rows[i].getAttribute ('class') + ' even');
			else rows[i].setAttribute ('class', rows[i].getAttribute ('class') + ' odd');
		}
	}
}