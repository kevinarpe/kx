"""ksql access utilities

Loading this module makes kdb library available to the embeded k.

For example, ds function converts strings to dates
>>> k('.d.ds["2003-08-04"]')
k("-11473")

In addition, this module defines convinience functions in .k.f
directory to extend ksql functionality.

Function fillnil is useful to work around kdb's inability to fill _n values

>>> print ksql("f.fillnil[(first(),(1,2),(3,4)), int()]")
(!0
 1 2
 3 4)

Function dow returns the day of the week (0=monday)
>>> print ksql("f.dow[date'2003-08-04']")
0
"""
__version__ = '$Revision: 1.2 $'
from K import k
from datetime import date

def ksql(q,*args):
    """provides a way to call ksql function without typing .d.r

    >>> ksql("date'2003-08-04'")
    k("-11473")

    Parametric queries are supported
    
    >>> ksql("asc ?", [1, 2, 3, 5])
    k("1 2 3 5")
    """
    if args:
        #r = k('{.d.r("%s";x)}' % q)(args)
        r = k('.d.r')((q,args))
    else:
        r = k('.d.r"%s"' % q)
    return r

_k_to_py_ord_shift = None
def k_to_py_ord_shift():
    """returns the difference between python and k ordinals for the same date.

    >>> print k_to_py_ord_shift()
    742904
    """
    global _k_to_py_ord_shift
    if _k_to_py_ord_shift is None:
        dte = date(2003,8,4)
        py_ord = dte.toordinal()
        k_ord = int(ksql("date('2003-08-04')"))
        _k_to_py_ord_shift = py_ord - k_ord
    return _k_to_py_ord_shift

    
def pyord_to_kord(pyordinal):
    """from py ordinal to ordinal date in k 
    >>> a = date(2003,8,4).toordinal()
    >>> kord = pyord_to_kord(a)
    >>> b = ksql("x:date(%s)" % kord)
    >>> int(ksql("x.year"))
    2003
    >>> print k('.d.sd x')
    "2003-08-04"
    """
    return pyordinal - k_to_py_ord_shift()

def kord_to_pyord(kord):
    """from k ordinal to py ordinal
    >>> pyord = date(2003,8,4).toordinal()
    >>> kord = pyord_to_kord(pyord)
    >>> pyord == kord_to_pyord(kord)
    True
    """
    return kord + k_to_py_ord_shift()


def table_loaded(table):
    return not int(k(".k[`%s]~_n" % table))
# Loads 'db' in k when this module is loaded
# and defines some useful functions in f directory
k(r'\l db')
k("f.fillnil:{@[x;&_n~'x;y]};"
  "f.nil:(_n~)';"
  "f.dow:{x!7};")

################################################################################
def _test():
    import doctest, ksql
    doctest.testmod(ksql)
if __name__ == '__main__':
    _test()
