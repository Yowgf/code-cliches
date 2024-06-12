wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x dotnet-install.sh
./dotnet-install.sh --channel LTS

mkdir XUnitTestDemo
cd XUnitTestDemo
dotnet new console -n XUnitTestDemo
dotnet new sln -n XUnitTestDemo
dotnet sln add XUnitTestDemo/XUnitTestDemo.csproj

dotnet new xunit -n XUnitTestDemo.Tests
dotnet sln add XUnitTestDemo.Tests/XUnitTestDemo.Tests.csproj
dotnet add XUnitTestDemo.Tests/XUnitTestDemo.Tests.csproj reference XUnitTestDemo/XUnitTestDemo.csproj

# Create UnitTest1.cs in XUnitTestDemo.Tests with the test code
# Ensure Program.cs in XUnitTestDemo has the Add method

dotnet test
