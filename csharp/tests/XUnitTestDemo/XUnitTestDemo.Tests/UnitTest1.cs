// XUnitTestDemo.Tests/UnitTest1.cs
using Xunit;
using XUnitTestDemo;

namespace XUnitTestDemo.Tests
{
    public class UnitTest1
    {
        [Fact]
        public void Test1()
        {
            var program = new Program();
            var result = program.Add(2, 3);
            Assert.Equal(5, result);
        }
    }
}
