#
# Base
#

# Set image
FROM debian:10 AS base


#
# Pre-Install
#

# General
RUN apt update
RUN apt upgrade -y
RUN apt dist-upgrade -y
RUN apt install wget -y
RUN apt install apt-utils -y


#
# Install mono
#

# Workdir
WORKDIR /setup/mono

# Prepare mono installation
RUN apt install apt-transport-https dirmngr gnupg ca-certificates -y
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb https://download.mono-project.com/repo/debian stable-buster main" | tee /etc/apt/sources.list.d/mono-official-stable.list
RUN apt update

# Install mono/nuget
RUN apt install mono-complete -y
RUN apt install nuget -y


#
# Install .net core 3.1
#

# Workdir
WORKDIR /setup/dotnet

# Prepare dotnet installation
RUN wget -O- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
RUN mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
RUN wget https://packages.microsoft.com/config/debian/10/prod.list
RUN mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
RUN chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
RUN chown root:root /etc/apt/sources.list.d/microsoft-prod.list

# Install dotnet
RUN apt-get update
RUN apt-get install apt-transport-https -y
RUN apt-get update
RUN apt-get install dotnet-sdk-3.1 -y