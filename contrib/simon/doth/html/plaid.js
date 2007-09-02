

// source: http://www.quirksmode.org/dom/getElementsByTagNames.html
function getElementsByTagNames(list,obj) {
	if (!obj) var obj = document;
	var tagNames = list.split(',');
	var resultArray = new Array();
	for (var i=0;i<tagNames.length;i++) {
		var tags = obj.getElementsByTagName(tagNames[i]);
		for (var j=0;j<tags.length;j++) {
			resultArray.push(tags[j]);
		}
	}
	var testNode = resultArray[0];
	if (!testNode) return [];
	if (testNode.sourceIndex) {
		resultArray.sort(function (a,b) {
				return a.sourceIndex - b.sourceIndex;
		});
	}
	else if (testNode.compareDocumentPosition) {
		resultArray.sort(function (a,b) {
				return 3 - (a.compareDocumentPosition(b) & 6);
		});
	}
	return resultArray;
}

/*
 * plaid
 *
 * A JavaScript class for dynamically striping HTML data tables.
 *
 * @author Aaron Collegeman <acollegeman@clutch-inc.com>
 * @version 1.0.0 2006/30/31
 *
 */

function plaid() {

	// some sensible row-color defaults
	var _evenRowColor = 'white';
	var _oddRowColor = '#eee';
	var _specialRowColor = 'black';
	var _reverseSpecialRowTextColor = true;
	var _specialColColor = 'black';
	var _reverseSpecialColTextColor = true;
	var _evenOverlapColor = '#bbb';
	var _oddOverlapColor = '#ddd';
	var _overlapOnClass = null;
	var _paintOverlap = false;

	/*
	 * Performs the formatting configured in this plaid object.
	 * @className Optional; only fix those tables with this class name
	 */
	this.stripe = function(className) {

		var allTables = getElementsByTagNames('table');

		for (var i=0; i<allTables.length; i++) {
			var table = allTables[i];

			if (className && table.className != className)
				continue;

			var tbody;

			for (var c=0; c<table.childNodes.length; c++)
				if (table.childNodes[c].nodeName.toLowerCase() == 'tbody')
					tbody = table.childNodes[c];

			var rowCount = 0;
			var overlapOnCol = new Array();
			for (var c=0; c<tbody.childNodes.length; c++) {

				if (tbody.childNodes[c].nodeName.toLowerCase() == 'tr') {
					var tr = tbody.childNodes[c];
					if (rowCount % 2 == 0)
						tr.style.backgroundColor = _evenRowColor;
					else
						tr.style.backgroundColor = _oddRowColor;

					if (_paintOverlap) {
						var colCount = 0;
						for (var col=0; col<tr.childNodes.length; col++) {
							var node = tr.childNodes[col];
							var nodeName = node.nodeName.toLowerCase();
							if (nodeName == 'th' || nodeName == 'td') {
								//if ((_overlapOnClass && (node.className == _overlapOnClass || overlapOnCol[col] == true)) || (!_overlapOnClass && colCount % 2 != 0)) {
								if ((_overlapOnClass && (node.className == _overlapOnClass || overlapOnCol[colCount])) || (!_overlapOnClass && colCount % 2 != 0)) {
									overlapOnCol[colCount] = true;
									if (rowCount % 2)
										node.style.backgroundColor = _evenOverlapColor;
									else
										node.style.backgroundColor = _oddOverlapColor;
								}
								colCount++;
							}
						}
					}

					rowCount++;
				}
			}
		}
	}

	this.setEvenRowColor = function(color) {
		_evenRowColor = color;
	}

	this.setOddRowColor = function(color) {
		_oddRowColor = color;
	}

	this.setSpecialRowColor = function(color) {
		_specialRowColor = color;
	}

	this.setReverseSpecialRowTextColor = function(color) {
		_reverseSpecialRowTextColor = color;
	}

	this.setSpecialColColor = function(color) {
		_specialColColor = color;
	}

	this.setReverseSpecialColTextColor = function(color) {
		_specialColTextColor = color;
	}

	this.setEvenOverlapColor = function(color) {
		_evenOverlapColor = color;
	}

	this.setOddOverlapColor = function(color) {
		_oddOverlapColor = color;
	}

	this.setOverlapOnClass = function(color) {
		_overlapOnClass = color;
		_paintOverlap = true;
	}

	this.setPaintOverlap = function(b) {
		_paintOverlap = b;
	}

}
