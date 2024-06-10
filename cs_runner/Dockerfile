FROM mcr.microsoft.com/dotnet/sdk:6.0
RUN apt-get update && apt-get install -y procps
COPY commands.sh /app/commands.sh
RUN ["chmod", "+x", "/app/commands.sh"]
ENTRYPOINT ["/app/commands.sh"]
WORKDIR /app
RUN dotnet new console
