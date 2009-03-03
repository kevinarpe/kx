using System;
using System.Linq;
using Xunit;

namespace KLinqTests
{
    public class TestGroupByandOrders : TestQBase
    {
        public TestGroupByandOrders()
        {
            ktc = new TestKdbContext(null);
        }

        [Fact(Skip="not implemented")]
        public void TestGB1()
		{
            var q = from srec in ktc.sRecord group new { srec.name, srec.status } by srec.city;
            CheckTranslation("?[s;();(enlist `city)!enlist `city;`name`status!`name`status]", q);
        }
    }
}
