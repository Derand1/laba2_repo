FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app
COPY MyFirstCI.Api/*.csproj ./MyFirstCI.Api/
COPY MyFirstCI.Tests/*.csproj ./MyFirstCI.Tests/
COPY *.sln ./
RUN dotnet restore
COPY . .
RUN dotnet publish MyFirstCI.Api/MyFirstCI.Api.csproj -c Release -o /app/out
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
COPY --from=build /app/out .
COPY appsettings*.json ./
ENTRYPOINT ["dotnet", "MyFirstCI.Api.dll"]
