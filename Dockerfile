FROM mcr.microsoft.com/dotnet/sdk:9.0 AS restore
WORKDIR /src
COPY MyFirstCI.Api/*.csproj ./MyFirstCI.Api/
COPY MyFirstCI.Tests/*.csproj ./MyFirstCI.Tests/
COPY MyFirstCI.sln .
RUN dotnet restore
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY --from=restore /src/. .
COPY . .
RUN dotnet publish MyFirstCI.Api/MyFirstCI.Api.csproj -c Release -o out
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:8080
COPY --from=build /src/out .
EXPOSE 8080
ENTRYPOINT ["dotnet", "MyFirstCI.Api.dll"]
