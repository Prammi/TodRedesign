FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.1-sdk AS build
RUN apt-get update -yq && apt-get upgrade -yq && apt-get install -yq curl git nano
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install -yq nodejs build-essential
RUN npm install -g npm
RUN npm install -g @angular/cli
WORKDIR /src
COPY ["Deloitte.TalentOnDemand.Web.csproj", ""]
RUN dotnet restore "Deloitte.TalentOnDemand.Web.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "Deloitte.TalentOnDemand.Web.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "Deloitte.TalentOnDemand.Web.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Deloitte.TalentOnDemand.Web.dll"]