#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["adhped-svc/adhped-svc.csproj", "adhped-svc/"]
RUN dotnet restore "adhped-svc/adhped-svc.csproj"
COPY . .
WORKDIR "/src/adhped-svc"
RUN dotnet build "adhped-svc.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "adhped-svc.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "adhped-svc.dll"]